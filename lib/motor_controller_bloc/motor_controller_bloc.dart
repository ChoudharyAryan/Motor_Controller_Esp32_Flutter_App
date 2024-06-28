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
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    final deniedPermission = <Permission>[];
    statuses.forEach((permission, status) {
      if (status == PermissionStatus.denied) {
        deniedPermission.add(permission);
      }
    });

    if (deniedPermission.isNotEmpty) {
      final deniedPermissionNames = deniedPermission
          .map((permission) => permission.toString())
          .join(', ');
      throw Exception('Permission denied for: $deniedPermissionNames');
    }
  }

  String _messageBuffer = '';
  StreamSubscription? streamSubscriptiondata;
  String incomingData = '';
  DateTime _lastDiscoveryTime = DateTime.now();
  Set<String> discoveredDevices = {};
  MotorControllerBloc()
      : super(const MotorControllerInitial(
          isConnecting: false,
          isDiscovering: false,
          isloading: false,
        )) {
    on<StartDiscovery>(_startDiscovery);
    on<ConnectToDeviceAndStartListening>(_connectToDeviceAndStartListening);
    on<Disconnect>(_disconnect);
    on<SendMessage>(_sendMessage);
    on<EmitInitial>(_emitInitial);
  }

  void _emitInitial(EmitInitial event, Emitter<MotorControllerState> emit) {
    emit(const MotorControllerInitial(
      isDiscovering: false,
      isConnecting: false,
      isloading: false,
    ));
  }

  void _startDiscovery(
      StartDiscovery event, Emitter<MotorControllerState> emit) async {
    if (DateTime.now().difference(_lastDiscoveryTime).inSeconds < 1) {
      //log('it kicked me out');
      return;
    }
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    //log(_bluetoothState.toString());
    final bluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (bluetoothEnabled != null && !bluetoothEnabled) {
      //log('am i even asking for permission');
      await FlutterBluetoothSerial.instance.openSettings();
    }
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      // Request to enable location services
      _serviceEnabled = await location.requestService();
    }

    try {
      await needPermission();
    } on Exception catch (e) {
      log('$e');
      emit(MotorControllerException(
        isDiscovering: false,
        isConnected: false,
        string: e.toString().replaceFirst('Exception: ', ''),
        isConnecting: false,
      ));
      emit(const MotorControllerInitial(
        isDiscovering: false,
        isConnecting: false,
        isloading: false,
      ));
      return;
    }

    discoveredDevices.clear();
    event.results.clear();
    _lastDiscoveryTime = DateTime.now();
    //log('inside the _startDiscovery function');

    emit(const MotorControllerDiscovering(
        isDiscoverd: false,
        isDiscovering: true,
        loadingText: 'looking for devices...',
        isloading: true,
        isConnecting: false,
        results: [],
        exception: null));

    try {
      // log('Inside the try catch block of _startDiscovery');
      await for (BluetoothDiscoveryResult r in FlutterBluetoothSerial.instance
          .startDiscovery()
          .where((r) => r.device.name?.startsWith('ESP32') ?? false)) {
        //log(r.device.name.toString());
        //log('adding the discovey result to the list');
        if (!discoveredDevices.contains(r.toString())) {
          event.results.add(r);
          discoveredDevices.add(r.toString());
          emit(MotorControllerDiscovering(
              isDiscovering: true,
              isDiscoverd: false,
              isloading: false,
              isConnecting: false,
              results: event.results,
              exception: null));
          //log('discovery result is ${r.device.name}');
        }
      }
    } on Exception catch (e) {
      // log('There is an exception inside the _startDiscovery function $e');
      emit(MotorControllerInitial(
          string: e.toString().contains('no_permissions')
              ? 'Bluetooth and Location Acess Required'
              : e.toString().contains('PermissionHandler.PermissionManager')
                  ? 'A request permission is already running'
                  : e.toString().replaceFirst('Exceptions: ', ''),
          isConnecting: false,
          isloading: false,
          isDiscovering: false));
    }

    if (event.results.isEmpty) {
      log('results list is empty');
      emit(MotorControllerInitial(
          isloading: false,
          isDiscovering: false,
          isConnecting: false,
          string: AppLocalizations.of(event.context)!.dnf));
    }
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
          isloading: true,
          loadingText: 'connecting...',
          isDiscovering: false,
          isDiscovered: false,
          isConnecting: true,
          exception: null));
      try {
        //log('INSIDE the try catch bloc of _connectTODeviceANdSTsrtListening');
        await BluetoothConnection.toAddress(event.device.address)
            .then((_connection) async {
          //log('Pressed the button too many times');
          connection = _connection;

          try {
            //log('have connection and about to begin start listening');
            _dataController?.close();
            _dataController = StreamController<String>();
            streamSubscriptiondata?.cancel();
            streamSubscriptiondata = connection?.input?.listen(_onDataRecived);
            //log('What is the probelem $incomingData');
            //await _sendMessage(const SendMessage('i'), emit);
            //log('came back and now going to emit state Connectedadn Listening');

            emit(MotorControllerConnectedAndListening(
                isDiscovering: false,
                isConnecting: false,
                isloading: false,
                isConnected: true,
                data: incomingData,
                exception: null));
          } on Exception catch (e) {
            // log('there is an exception inside the emitting the MotorControllerConnectedAndListening $e');
            connection?.dispose();
            _dataController?.close();
            emit(MotorControllerException(
              string: e.toString().contains('no_permissions')
                  ? 'Please enable location and bluetooth permission'
                  : e.toString().replaceFirst('Exception: ', ''),
              isConnected: true,
              isConnecting: false,
              isDiscovering: false,
            ));
            emit(const MotorControllerInitial(
              isDiscovering: false,
              isConnecting: false,
              isloading: false,
            ));
            return;
          }
        });
      } on Exception catch (e) {
        //log('There is an exception inside the _ConnectedToDeviceANdStartLidtening function $e');
        connection?.dispose();
        _dataController?.close();
        emit(MotorControllerException(
            string: e.toString().contains('connect_error, read failed')
                ? 'Check the Peripheral Device is on and can be connected to'
                : e.toString().replaceFirst('Exception: ', ''),
            isConnected: false,
            isConnecting: false,
            isDiscovering: false));
        emit(const MotorControllerInitial(
          isDiscovering: false,
          isloading: false,
          isConnecting: false,
        ));
      }
    } else {
      // Handle the case where the user denied Bluetooth permission
      emit(MotorControllerException(
        string: 'Bluetooth permission denied',
        isConnected: false,
        isConnecting: false,
        isDiscovering: false,
      ));
      emit(const MotorControllerInitial(
        isDiscovering: false,
        isloading: false,
        isConnecting: false,
      ));
    }
    // _sendMessage(const SendMessage('i'), emit);
  }

  Future<void> _sendMessage(
      SendMessage event, Emitter<MotorControllerState> emit) async {
    if (!_bluetoothState.isEnabled) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    if (!(await location.serviceEnabled())) {
      await location.requestService();
    }
    if (connection != null && connection!.isConnected) {
      try {
        //log('Inside the sendMessage function');
        //log(event.text);

        String text = event.text;
        text = text.trim();
        //log('trimed the text');
        connection?.output.add(utf8.encode("$text\r\n"));
        //log('going to wait for the data to be sent');
        await connection?.output.allSent;
        log(text);
      } on Exception catch (e) {
        //log('There is an exception inside the _sendMessage function');
        //log('exceptio is : $e');
        if (!emit.isDone) {
          emit(MotorControllerException(
              string: e.toString(),
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
          isloading: false,
          str: 'The Bowler Got disconnected!',
          results: const [],
          isDisconnecting: false,
          isConnecting: false));
    }
  }

  void _disconnect(Disconnect event, Emitter<MotorControllerState> emit) async {
    try {
      //log('Disconnect Function');
      if (event.results.isNotEmpty) {
        event.results.clear();
      }

      for (int i = 0; i < event.list.length; i++) {
        //log('ok so i am inside the for loop');
        if (event.list[i][2] == true) {
          //log('i found the true value');
          event.list[i][2] = false;
        }
      }
      connection?.dispose();
      await streamSubscriptiondata?.cancel();
      streamSubscriptiondata = null;
      await _dataController?.close();
    } on Exception catch (e) {
      //log('There is an exception inside the _disconnect function');
      emit(MotorControllerException(
          string: e.toString(),
          isConnected: true,
          isConnecting: false,
          isDiscovering: false));
    }
    emit(MotorControllerDisconnected(
        exception: null,
        isDiscovering: false,
        isloading: false,
        str: null,
        isConnecting: false,
        results: event.results,
        isDisconnecting: event.isDisconnecting));
    // emit(const MotorControllerInitial(
    //     isDiscovering: false, isConnecting: false));
  }

  @override
  Future<void> close() async {
    //log('CLOSE FUNCTION');
    await _dataController?.close();
    await streamSubscriptiondata?.cancel();
    connection?.dispose();
    //log('inside the close function');

    return super.close();
  }

  _onDataRecived(Uint8List data) {
    //log('inside the _onDataRecived Function in motor_controller_bloc');
    //log('$data');
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
    //log('what is inside the incomingData variable : $incomingData');
    _dataController?.add(incomingData);
    emit(MotorControllerConnectedAndListening(
        isDiscovering: false,
        isConnecting: false,
        isloading: false,
        isConnected: true,
        data: incomingData,
        exception: null));

    log(" Data is incoming $incomingData");
  }
}
