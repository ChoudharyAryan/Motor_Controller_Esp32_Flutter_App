import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:motor_controller_esp32/BluetoothDeviceListEntry.dart';
import 'package:motor_controller_esp32/GenericSnackBar.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  List<BluetoothDiscoveryResult> results = [];
  bool isLedON = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MotorControllerBloc(),
      child: BlocBuilder<MotorControllerBloc, MotorControllerState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: state.isDiscovering
                    ? const Text('Discovering devices')
                    : state.isDiscovered
                        ? const Text('Select a device to connect')
                        : state.isConnected
                            ? const Text('play to your hearts content')
                            : const Text('FLutter BLue tooth serial'),
                actions: [
                  state.isDiscovering
                      ? FittedBox(
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple),
                            ),
                          ),
                        )
                      : state.isDiscovered
                          ? IconButton(
                              icon: const Icon(Icons.replay),
                              onPressed: () => context
                                  .read<MotorControllerBloc>()
                                  .add(StartDiscovery(results)),
                            )
                          : state.isConnected
                              ? IconButton(
                                  onPressed: () => context
                                      .read<MotorControllerBloc>()
                                      .add(Disconnect(
                                          results: results,
                                          isDisconnecting: true)),
                                  icon: const Icon(Icons.logout_rounded),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.replay),
                                  onPressed: () => context
                                      .read<MotorControllerBloc>()
                                      .add(StartDiscovery(results)),
                                )
                ],
              ),
              body: state.isDiscovering || state.isDiscovered
                  ? ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (BuildContext context, index) {
                        BluetoothDiscoveryResult result = results[index];
                        return BluetoothDeviceListEntry(
                            device: result.device,
                            rssi: result.rssi,
                            onTap: () => context
                                .read<MotorControllerBloc>()
                                .add(ConnectToDeviceAndStartListening(
                                    result.device)));
                      },
                    )
                  : state.isConnecting
                      ? const CircularProgressIndicator()
                      : state.isConnected
                          ? Column(
                              children: [
                                CupertinoButton(
                                    onPressed: () {
                                      context
                                          .read<MotorControllerBloc>()
                                          .add(SendMessage('aryan'));

                                      setState(() {
                                        isLedON = !isLedON;
                                      });
                                    },
                                    child: isLedON
                                        ? const Text('Toogle off')
                                        : const Text('Toogle on')),
                                StreamBuilder(
                                    stream: context
                                        .read<MotorControllerBloc>()
                                        .dataStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        log('snaphasdata');
                                        return Text(snapshot.data!);
                                      } else if (snapshot.hasError) {
                                        log('error in snapshot ${snapshot.error}');
                                        return Text(snapshot.error.toString());
                                      } else {
                                        return const Text('ball speed');
                                      }
                                    })
                              ],
                            )
                          : Container(
                              child: ListView(
                                children: <Widget>[
                                  const Divider(),
                                  const ListTile(title: Text('General')),
                                  ListTile(
                                    title: const Text('Bluetooth status'),
                                    subtitle: Text(state.toString()),
                                    trailing: ElevatedButton(
                                      child: const Text('Settings'),
                                      onPressed: () {
                                        try {
                                          FlutterBluetoothSerial.instance
                                              .openSettings();
                                        } catch (e) {
                                          ShowSnackBarClass.ShowErrorSnackBar(
                                              context, e.toString());
                                        }
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: ElevatedButton(
                                        child: const Text(
                                            'Connect to paired device to chat with ESP32'),
                                        onPressed: () async {
                                          log('Button pressed to start the discovery');
                                          context
                                              .read<MotorControllerBloc>()
                                              .add(StartDiscovery(results));
                                        }),
                                  ),
                                ],
                              ),
                            ));
        },
      ),
    );
  }
}
