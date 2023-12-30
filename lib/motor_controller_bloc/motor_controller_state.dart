part of 'motor_controller_bloc.dart';

@immutable
abstract class MotorControllerState extends Equatable {
  final bool isDiscovering;
  final bool isConnecting;
  final bool isConnected;
  final bool isDisconnected;
  final String? string;
  final bool isloading;
  final bool isDiscoverd;
  final BluetoothDiscoveryResult? discoveryResult;
  final BluetoothDevice? device;
  final Exception? exception;
  final Stream<String>? data;
  const MotorControllerState(
      {this.isConnected = false,
      this.isDisconnected = false,
      this.string,
      this.exception,
      this.isloading = true,
      this.isDiscoverd = false,
      this.data,
      this.discoveryResult,
      this.device,
      required this.isConnecting,
      required this.isDiscovering});

  @override
  List<Object> get props => [isDiscovering, isConnecting];
}

class MotorControllerInitial extends MotorControllerState {
  final String? string;
  const MotorControllerInitial({
    required bool isDiscovering,
    this.string,
    required bool isConnecting,
  }) : super(
          isDisconnected: true,
          string: string,
          isDiscovering: isDiscovering,
          isConnecting: isConnecting,
        );
}

class MotorControllerDiscovering extends MotorControllerState {
  final List<BluetoothDiscoveryResult> results;
  final bool isloading;
  final Exception? exception;
  const MotorControllerDiscovering(
      {required bool isDiscovering,
      required this.isloading,
      required bool isConnecting,
      required bool isDiscoverd,
      required this.exception,
      required this.results})
      : super(
          isDiscovering: isDiscovering,
          isDiscoverd: isDiscoverd,
          isConnecting: isConnecting,
          isloading: isloading,
        );
  @override
  List<Object> get props => [isDiscovering, isConnecting, results];
}

class MotorControllerConnecting extends MotorControllerState {
  final Exception? exception;
  final bool isDiscovering;
  final bool isConnecting;
  final bool isDiscovered;
  const MotorControllerConnecting(
      {required this.isConnecting,
      required this.exception,
      required this.isDiscovered,
      required this.isDiscovering})
      : super(
            isDiscoverd: isDiscovered,
            isDiscovering: isDiscovering,
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
  final String? str;
  final List<BluetoothDiscoveryResult> results;
  MotorControllerDisconnected({
    required this.exception,
    required bool isDiscovering,
    required this.results,
    required this.isDisconnecting,
    required this.str,
    required bool isConnecting,
  }) : super(
            string: str,
            isConnecting: isConnecting,
            isDisconnected: true,
            isDiscovering: isDiscovering,
            exception: exception);
}

class MotorControllerException extends MotorControllerState {
  final Exception exception;
  final bool isDiscovering;
  final bool isConnecting;
  final bool isConnected;
  MotorControllerException(
      {required this.exception,
      required this.isConnected,
      required this.isConnecting,
      required this.isDiscovering})
      : super(
          isConnecting: false,
          isDiscovering: false,
          exception: exception,
        );
}
