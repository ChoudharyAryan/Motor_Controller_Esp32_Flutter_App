part of 'motor_controller_bloc.dart';

@immutable
abstract class MotorControllerEvent {
  const MotorControllerEvent();
}

class StartDiscovery extends MotorControllerEvent {
  final List<BluetoothDiscoveryResult> results;
  final BuildContext context;
  const StartDiscovery(this.results, this.context);
}

class ConnectToDeviceAndStartListening extends MotorControllerEvent {
  final BluetoothDevice device;
  const ConnectToDeviceAndStartListening(this.device);
}

class SendMessage extends MotorControllerEvent {
  final String text;
  const SendMessage(this.text);
}

class Disconnect extends MotorControllerEvent {
  final bool isDisconnecting;
  final List<BluetoothDiscoveryResult> results;
  final List list;
  const Disconnect(
      {this.isDisconnecting = false,
      required this.results,
      required this.list});
}

class EmitInitial extends MotorControllerEvent {
  const EmitInitial();
}
