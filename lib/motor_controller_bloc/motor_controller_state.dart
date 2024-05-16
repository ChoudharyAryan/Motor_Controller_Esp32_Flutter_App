part of 'motor_controller_bloc.dart';

@immutable
abstract class MotorControllerState extends Equatable {
  final bool isDiscovering;
  final bool isConnecting;
  final bool isConnected;
  final bool isDisconnected;
  final String? string;
  final bool isloading;
  final String loadingText;
  final bool isDiscoverd;
  final BluetoothDiscoveryResult? discoveryResult;
  final BluetoothDevice? device;
  final Exception? exception;
  final Stream<String>? data;
  const MotorControllerState(
      {this.isConnected = false,
      this.isDisconnected = false,
      this.loadingText = 'please wait',
      this.string,
      this.exception,
      this.isloading = false,
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
  final bool isloading;
  const MotorControllerInitial({
    required bool isDiscovering,
    required this.isloading,
    this.string,
    required bool isConnecting,
  }) : super(
          isloading: isloading,
          isDisconnected: true,
          string: string,
          isDiscovering: isDiscovering,
          isConnecting: isConnecting,
        );
}

class MotorControllerDiscovering extends MotorControllerState {
  final List<BluetoothDiscoveryResult> results;
  final bool isloading;
  final String loadingText;
  final Exception? exception;
  const MotorControllerDiscovering(
      {required bool isDiscovering,
      required this.isloading,
      this.loadingText = 'please wait',
      required bool isConnecting,
      required bool isDiscoverd,
      required this.exception,
      required this.results})
      : super(
            isDiscovering: isDiscovering,
            isDiscoverd: isDiscoverd,
            isConnecting: isConnecting,
            isloading: isloading,
            loadingText: loadingText);
  @override
  List<Object> get props => [isDiscovering, isConnecting, results];
}

class MotorControllerConnecting extends MotorControllerState {
  final Exception? exception;
  final bool isDiscovering;
  final bool isConnecting;
  final String loadingText;
  final bool isDiscovered;
  final bool isloading;
  const MotorControllerConnecting(
      {required this.isConnecting,
      this.loadingText = 'please wait',
      required this.isloading,
      required this.exception,
      required this.isDiscovered,
      required this.isDiscovering})
      : super(
            isloading: isloading,
            loadingText: loadingText,
            isDiscoverd: isDiscovered,
            isDiscovering: isDiscovering,
            isConnecting: isConnecting,
            exception: exception);
}

class MotorControllerConnectedAndListening extends MotorControllerState {
  final Exception? exception;
  final Stream<String> data;
  final bool isloading;
  const MotorControllerConnectedAndListening({
    required bool isDiscovering,
    required bool isConnecting,
    required this.isloading,
    required bool isConnected,
    required this.data,
    required this.exception,
  }) : super(
            exception: exception,
            isloading: isloading,
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
  final bool isloading;
  final String? str;
  final List<BluetoothDiscoveryResult> results;
  MotorControllerDisconnected({
    required this.exception,
    required bool isDiscovering,
    required this.results,
    required this.isDisconnecting,
    required this.isloading,
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
  final String string;
  final bool isDiscovering;
  final bool isConnecting;
  final bool isConnected;
  MotorControllerException(
      {required this.string,
      required this.isConnected,
      required this.isConnecting,
      required this.isDiscovering})
      : super(
          isConnecting: false,
          isDiscovering: false,
          string: string,
        );
}
