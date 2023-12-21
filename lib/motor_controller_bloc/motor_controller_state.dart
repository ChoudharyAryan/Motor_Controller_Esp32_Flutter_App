part of 'motor_controller_bloc.dart';

@immutable
abstract class MotorControllerState extends Equatable {
  final bool isDiscovering;
  final bool isConnecting;
  final bool isConnected;
  final BluetoothDiscoveryResult? discoveryResult;
  final BluetoothDevice? device;
  final Exception? exception;
  final Stream<String>? data;
  final bool isDiscovered;
  const MotorControllerState(
      {this.isConnected = false,
      this.exception,
      this.data,
      this.discoveryResult,
      this.device,
      this.isDiscovered = false,
      required this.isConnecting,
      required this.isDiscovering});

  @override
  List<Object> get props => [isDiscovering, isConnecting];
}

class MotorControllerInitial extends MotorControllerState {
  const MotorControllerInitial({
    required bool isDiscovering,
    required bool isConnecting,
  }) : super(isDiscovering: isDiscovering, isConnecting: isConnecting);
}

class MotorControllerDiscovering extends MotorControllerState {
  final List<BluetoothDiscoveryResult> results;
  const MotorControllerDiscovering(
      {required bool isDiscovering,
      required bool isConnecting,
      required this.results})
      : super(isDiscovering: isDiscovering, isConnecting: isConnecting);
  @override
  List<Object> get props => [isDiscovering, isConnecting, results];
}

class MotorControllerDiscoveringDone extends MotorControllerState {
  final bool isDiscoverd;
  const MotorControllerDiscoveringDone({required this.isDiscoverd})
      : super(
            isConnecting: false,
            isDiscovering: false,
            isDiscovered: isDiscoverd);
}

class MotorControllerConnecting extends MotorControllerState {
  final Exception? exception;
  const MotorControllerConnecting(
      {required bool isConnecting, required this.exception})
      : super(
            isDiscovering: false,
            isConnecting: isConnecting,
            exception: exception);
}

class MotorControllerConnectedAndListening extends MotorControllerState {
  final Exception? exception;
  final Stream<String> data;
  const MotorControllerConnectedAndListening({
    required bool isDiscovering,
    required bool isConnecting,
    required bool isConnected,
    required this.data,
    required this.exception,
  }) : super(
            exception: exception,
            isConnecting: isConnecting,
            isDiscovering: isDiscovering,
            data: data,
            isConnected: isConnected);

  @override
  List<Object> get props => [isDiscovering, isConnecting, data];
}

class MotorControllerDisconnected extends MotorControllerState {
  final Exception? exception;
  final bool isDisconnecting;
  final List<BluetoothDiscoveryResult> results;
  MotorControllerDisconnected({
    required this.exception,
    required bool isDiscovering,
    required this.results,
    required this.isDisconnecting,
    required bool isConnecting,
  }) : super(
            isConnecting: isConnecting,
            isDiscovering: isDiscovering,
            exception: exception);
}

class MotorControllerException extends MotorControllerState {
  final Exception exception;
  const MotorControllerException(
      {required this.exception,
      required bool isConnecting,
      required bool isDiscovering})
      : super(
            isConnecting: isConnecting,
            isDiscovering: isDiscovering,
            exception: exception);
}
