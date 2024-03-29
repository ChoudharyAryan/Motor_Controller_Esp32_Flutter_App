import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' show Location;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'motor_controller_event.dart';
part 'motor_controller_state.dart';

class MotorControllerBloc
    extends Bloc<MotorControllerEvent, MotorControllerState> {
  BluetoothConnection? connection;
  StreamController<String>? _dataController;
  Stream<String> get dataStream {
    _dataController ??= StreamController<String>();
    return _dataController!.stream;
  }

  late bool _serviceEnabled;

  Location location = new Location();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  Future<void> needPermission() async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.bluetooth,
    //   Permission.bluetoothScan,
    //   Permission.bluetoothConnect,
    //   Permission.location,
    //   // Add location permission if needed
    //   // ... add other permissions as needed
    // ].request();

    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.location.request();

    log('returining');
    // if (Permission.bluetooth.isGranted == true &&
    //     Permission.bluetoothConnect.isGranted == true &&
    //     Permission.bluetoothScan.isGranted == true &&
    //     Permission.location.isGranted == true) {
    //   log('permissions granted');
    //   return;
    // } else {
    //   log('did not get all the permission');
    // }
    if (await Permission.bluetooth.isGranted == true) {
      log('Bluetooth permission granted');
    }
    if (await Permission.bluetoothConnect.isGranted == true) {
      log('BluetoothConnect permission granted');
    }
    if (await Permission.bluetoothScan.isGranted == true) {
      log('BLuetoothScan permnisson granted');
    }
    if (await Permission.location.isGranted == true) {
      log('Bluetooth Location permission granted');
    }

    // if (statuses[Permission.bluetooth] != PermissionStatus.granted ||
    //     statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
    //     statuses[Permission.bluetoothConnect] != PermissionStatus.granted ||
    //     statuses[Permission.location] != PermissionStatus.granted) {
    //   throw Exception('Bluetooth permission denied');
    // } else {
    //   log('returning from function needPermission all permissions granted');
    //   return;
    // }

    // Add other permission checks and error handling as needed
  }

  String _messageBuffer = '';
  StreamSubscription? streamSubscriptiondata;
  String incomingData = '';
  DateTime _lastDiscoveryTime = DateTime.now();
  MotorControllerBloc()
      : super(const MotorControllerInitial(
          isConnecting: false,
          isDiscovering: false,
        )) {
    on<StartDiscovery>(_startDiscovery);
    on<ConnectToDeviceAndStartListening>(_connectToDeviceAndStartListening);
    on<Disconnect>(_disconnect);
    on<SendMessage>(_sendMessage);
    on<EmitInitial>(_emitInitial);
  }

  void _emitInitial(EmitInitial event, Emitter<MotorControllerState> emit) {
    emit(const MotorControllerInitial(
        isDiscovering: false, isConnecting: false));
  }

  void _startDiscovery(
      StartDiscovery event, Emitter<MotorControllerState> emit) async {
    if (DateTime.now().difference(_lastDiscoveryTime).inSeconds < 3) {
      return;
    }
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    log(_bluetoothState.toString());
    final bluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (bluetoothEnabled != null && !bluetoothEnabled) {
      log('am i even asking for permission');
      await FlutterBluetoothSerial.instance.openSettings();
    }
    await needPermission();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      // Request to enable location services
      _serviceEnabled = await location.requestService();
    }
    log('in the start discovery function again');
    // if (!_bluetoothState.isEnabled) {
    //   await FlutterBluetoothSerial.instance.requestEnable();
    //   // .then((_) => emit(const MotorControllerInitial(

    //   //       isDiscovering: false,
    //   //       isConnecting: false,

    //   //     )));
    // }
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.bluetooth,
    //   Permission.bluetoothConnect,
    //   // Permission.bluetoothScan,
    //   Permission.location
    // ].request();
    event.results.clear();
    _lastDiscoveryTime = DateTime.now();
    log('inside the _startDiscovery function');

    // if (statuses[Permission.bluetooth] == PermissionStatus.granted &&
    //     statuses[Permission.location] == PermissionStatus.granted &&
    //     // statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
    //     statuses[Permission.bluetoothConnect] == PermissionStatus.granted) {
    emit(const MotorControllerDiscovering(
        isDiscoverd: false,
        isDiscovering: true,
        isloading: false,
        isConnecting: false,
        results: [],
        exception: null));

    try {
      log('Inside the (try catch block of _startDiscovery');
      await for (BluetoothDiscoveryResult r in FlutterBluetoothSerial.instance
          .startDiscovery()
          .where((r) => r.device.name?.startsWith('ESP32') ?? false)) {
        log(r.device.name.toString());
        log('adding the discovey result to the list');
        event.results.add(r);
        emit(MotorControllerDiscovering(
            isDiscovering: true,
            isDiscoverd: false,
            isloading: false,
            isConnecting: false,
            results: event.results,
            exception: null));
        log('discovery result is ${r.device.name}');
      }
    } on Exception catch (e) {
      log('There is an exception inside the _startDiscovery function');
      emit(MotorControllerException(
          exception: e,
          isConnected: false,
          isConnecting: false,
          isDiscovering: false));
    }
    // } else {
    //   emit(const MotorControllerInitial(
    //       isDiscovering: false,
    //       isConnecting: false,
    //       string: 'bluetooth permission denied'));
    // }

    if (event.results.isEmpty) {
      log('results list is empty');
      emit(MotorControllerInitial(
          isDiscovering: false,
          isConnecting: false,
          string: AppLocalizations.of(event.context)!.dnf));
    }

    // emit(MotorControllerDiscovering(
    //     isDiscovering: false,
    //     isDiscoverd: true,
    //     isloading: false,
    //     isConnecting: false,
    //     results: event.results,
    //     exception: null));
  }

  void _connectToDeviceAndStartListening(ConnectToDeviceAndStartListening event,
      Emitter<MotorControllerState> emit) async {
    if (!_bluetoothState.isEnabled) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
    if (bluetoothStatus == PermissionStatus.granted) {
      emit(const MotorControllerConnecting(
          isDiscovering: false,
          isDiscovered: false,
          isConnecting: true,
          exception: null));
      try {
        log('INSIDE the try catch bloc of _connectTODeviceANdSTsrtListening');
        await BluetoothConnection.toAddress(event.device.address)
            .then((_connection) {
          log('Pressed the button too many times');
          connection = _connection;

          try {
            log('have connection and about to begin start listening');
            _dataController?.close();
            _dataController = StreamController<String>();
            streamSubscriptiondata?.cancel();
            streamSubscriptiondata = connection?.input?.listen(_onDataRecived);
            log('What is the probelem $incomingData');
            _sendMessage(const SendMessage('i'), emit);

            emit(MotorControllerConnectedAndListening(
                isDiscovering: false,
                isConnecting: false,
                isConnected: true,
                data: dataStream,
                exception: null));
          } on Exception catch (e) {
            log('there is an exception inside the emitting the MotorControllerConnectedAndListening');
            emit(MotorControllerException(
              exception: e,
              isConnected: true,
              isConnecting: false,
              isDiscovering: false,
            ));
          }
        });
      } on Exception catch (e) {
        log('There is an exception inside the _ConnectedToDeviceANdStartLidtening function');
        emit(MotorControllerException(
            exception: e,
            isConnected: false,
            isConnecting: false,
            isDiscovering: false));
      }
    } else {
      // Handle the case where the user denied Bluetooth permission
      emit(MotorControllerException(
        exception: Exception('Bluetooth permission denied'),
        isConnected: false,
        isConnecting: false,
        isDiscovering: false,
      ));
    }
  }

  void _sendMessage(
      SendMessage event, Emitter<MotorControllerState> emit) async {
    if (!_bluetoothState.isEnabled) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    if (connection != null && connection!.isConnected) {
      try {
        log('Inside the sendMessage function');
        log(event.text);

        String text = event.text;
        text = text.trim();
        log('trimed the text');
        connection?.output.add(utf8.encode("$text\r\n"));
        log('going to wait for the data to be sent');
        await connection?.output.allSent;
      } on Exception catch (e) {
        log('There is an exception inside the _sendMessage function');
        log('exceptio is : $e');
        if (!emit.isDone) {
          emit(MotorControllerException(
              exception: e,
              isConnected: true,
              isConnecting: false,
              isDiscovering: false));
        } else {
          log('returning');
          return;
        }
      }
    } else {
      emit(MotorControllerDisconnected(
          exception: null,
          isDiscovering: false,
          str: 'The Bowler Got disconnected!',
          results: const [],
          isDisconnecting: false,
          isConnecting: false));
    }
  }

  void _disconnect(Disconnect event, Emitter<MotorControllerState> emit) {
    try {
      log('Disconnect Function');
      if (event.results.isNotEmpty) {
        event.results.clear();
      }

      for (int i = 0; i < event.list.length; i++) {
        log('ok so i am inside the for loop');
        if (event.list[i][2] == true) {
          log('i found the true value');
          event.list[i][2] = false;
        }
      }
      connection?.dispose();
      streamSubscriptiondata?.cancel();
      streamSubscriptiondata = null;
      _dataController?.close();
    } on Exception catch (e) {
      log('There is an exception inside the _disconnect function');
      emit(MotorControllerException(
          exception: e,
          isConnected: true,
          isConnecting: false,
          isDiscovering: false));
    }
    emit(MotorControllerDisconnected(
        exception: null,
        isDiscovering: false,
        str: null,
        isConnecting: false,
        results: event.results,
        isDisconnecting: event.isDisconnecting));
    // emit(const MotorControllerInitial(
    //     isDiscovering: false, isConnecting: false));
  }

  @override
  Future<void> close() async {
    log('CLOSE FUNCTION');
    await _dataController?.close();
    await streamSubscriptiondata?.cancel();
    connection?.dispose();
    log('inside the close function');

    return super.close();
  }

  _onDataRecived(Uint8List data) {
    log('inside the _onDataRecived Function in motor_controller_bloc');
    log('$data');
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      incomingData = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString.substring(0, index);
      _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    log('what is inside the incomingData variable : $incomingData');
    _dataController?.add(incomingData);
  }
}
