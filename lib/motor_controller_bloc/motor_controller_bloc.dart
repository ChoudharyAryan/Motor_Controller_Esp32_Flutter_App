import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';

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

  String _messageBuffer = '';
  StreamSubscription? streamSubscriptiondata;
  String incomingData = '';
  MotorControllerBloc()
      : super(const MotorControllerInitial(
          isConnecting: false,
          isDiscovering: false,
        )) {
    on<StartDiscovery>(_startDiscovery);
    on<ConnectToDeviceAndStartListening>(_connectToDeviceAndStartListening);
    on<Disconnect>(_disconnect);
    on<SendMessage>(_sendMessage);
  }

  void _startDiscovery(
      StartDiscovery event, Emitter<MotorControllerState> emit) async {
    try {
      event.results.clear();
      log('Inside the (try catch block of _startDiscovery');
      await for (BluetoothDiscoveryResult r in FlutterBluetoothSerial.instance
          .startDiscovery()
          .where((r) => r.device.name?.startsWith('ESP32') ?? false)) {
        event.results.add(r);
        log('discovery result is ${r.device.name}');
        emit(MotorControllerDiscovering(
            isDiscovering: true, isConnecting: false, results: event.results));
      }
    } on Exception catch (e) {
      log('There is an exception inside the _startDiscovery function');
      emit(MotorControllerException(
          exception: e, isConnecting: false, isDiscovering: false));
    }

    log('Just Before the DiscoveringDone State');
    emit(const MotorControllerDiscoveringDone(isDiscoverd: true));
    log('Just after the DiscoveringDone state');
  }

  void _connectToDeviceAndStartListening(ConnectToDeviceAndStartListening event,
      Emitter<MotorControllerState> emit) async {
    emit(const MotorControllerConnecting(isConnecting: true, exception: null));
    try {
      log('INSIDE the try catch bloc of _connectTODeviceANdSTsrtListening');
      await BluetoothConnection.toAddress(event.device.address)
          .then((_connection) {
        connection = _connection;

        try {
          log('have connection and about to begin start listening');
          _dataController?.close();
          _dataController = StreamController<String>();
          streamSubscriptiondata?.cancel();
          streamSubscriptiondata = connection?.input?.listen(_onDataRecived);
          log('What is the probelem $incomingData');

          emit(MotorControllerConnectedAndListening(
              isDiscovering: false,
              isConnecting: false,
              isConnected: true,
              data: dataStream,
              exception: null));
        } on Exception catch (e) {
          log('there is an exception inside the emitting the MotorControllerConnectedAndListening');
          emit(MotorControllerConnectedAndListening(
              isDiscovering: false,
              isConnecting: false,
              isConnected: false,
              data: dataStream,
              exception: e));
        }
      });
    } on Exception catch (e) {
      emit(MotorControllerConnecting(isConnecting: false, exception: e));
    }
  }

  void _sendMessage(
      SendMessage event, Emitter<MotorControllerState> emit) async {
    try {
      log('Inside the sendMessage function');
      String text = event.text;
      text = text.trim();
      connection?.output.add(utf8.encode("$text\r\n"));
      await connection?.output.allSent;
    } on Exception catch (e) {
      emit(MotorControllerException(
          exception: e, isConnecting: false, isDiscovering: false));
    }
  }

  void _disconnect(Disconnect event, Emitter<MotorControllerState> emit) {
    try {
      log('Disconnect Function');
      event.results.clear();
      connection?.dispose();
      streamSubscriptiondata?.cancel();
      streamSubscriptiondata = null;
      _dataController?.close();
    } on Exception catch (e) {
      emit(MotorControllerException(
          exception: e, isConnecting: false, isDiscovering: false));
      return;
    }
    emit(MotorControllerDisconnected(
        exception: null,
        isDiscovering: false,
        isConnecting: false,
        results: event.results,
        isDisconnecting: event.isDisconnecting));
  }

  @override
  Future<void> close() async {
    log('CLOSE FUNCTION');
    await _dataController?.close();
    await streamSubscriptiondata?.cancel();
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
