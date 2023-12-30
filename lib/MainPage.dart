import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motor_controller_esp32/util/BluetoothDeviceListEntry.dart';
import 'package:motor_controller_esp32/util/GenericAlertDilog.dart';
import 'package:motor_controller_esp32/util/ball_box.dart';
import 'package:motor_controller_esp32/util/commButton.dart';
import 'package:motor_controller_esp32/util/myPopUp.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  List<BluetoothDiscoveryResult> results = [];
  bool isLedON = false;
  String username = 'user';
  bool isoff = false;
  late SharedPreferences pref;
  List typesOfBalls = [
    ['Normal', 'lib/images/stump.png', false, 'a', 1],
    ['Normal Fast', 'lib/images/stump.png', false, 'b', 2],
    ['Normal Slow', 'lib/images/stump.png', false, 'c', 3],
    ['Right Swing', 'lib/images/stump.png', false, 'd', 4],
    ['Left Swing', 'lib/images/stump.png', false, 'e', 5],
    // ['Right Spin', 'lib/images/stump.png', false, 'f'],
    // ['Left Spin', 'lib/images/stump.png', false, 'g'],
    // ['Yorker', 'lib/images/stump.png', false, 'h'],
  ];

  void powerSwitchHadChanged(bool value, int index) {
    setState(() {
      for (int i = 0; i < typesOfBalls.length; i++) {
        if (typesOfBalls[i][2] == true) {
          typesOfBalls[i][2] = false;
        }
      }
      typesOfBalls[index][2] = value;
    });
  }

  @override
  void initState() {
    _loadUserName();

    super.initState();
  }

  Future<void> _loadUserName() async {
    pref = await SharedPreferences.getInstance();
    username = pref.getString('username') ?? 'user';
    setState(() {});
  }

  Future<void> _updateUsername(String newUsername) async {
    await pref.setString('username', newUsername);
    _loadUserName();
  }

  void _startTimer() async {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // Trigger setState every 2 seconds
      setState(() {});
      //_startTimer();
    });
  }

  // int onsec() {
  //   int res = -1;
  //   for (int i = 0; i < typesOfBalls.length; i++) {
  //     if (typesOfBalls[i][2] == true) {
  //       res = i;
  //       break;
  //     }
  //   }
  //   return res;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MotorControllerBloc(),
      child: BlocListener<MotorControllerBloc, MotorControllerState>(
        listener: (context, state) {
          if (state is MotorControllerException) {
            if (state.exception is PlatformException) {
              ShowMyDilog(context,
                  'platform interaction failed: check your bluetooth connection');
              context.read<MotorControllerBloc>().add(const EmitInitial());
            } else {
              ShowMyDilog(context, state.exception.toString());
              context.read<MotorControllerBloc>().add(const EmitInitial());
            }
          } else if (state.string != null) {
            ShowErrorSnackBar(context, state.string!);
          }
          if (state is MotorControllerDiscovering) {
            //setState(() {});

            _startTimer();
          }
        },
        child: BlocBuilder<MotorControllerBloc, MotorControllerState>(
          builder: (context, state) {
            return Scaffold(
                floatingActionButton: !state.isDiscovering &&
                        !state.isConnecting &&
                        !state.isConnected
                    ? FloatingActionButton(
                        backgroundColor: Colors.grey[400],
                        onPressed: () {
                          context
                              .read<MotorControllerBloc>()
                              .add(StartDiscovery(results));
                        },
                        child: const Icon(
                          Icons.bluetooth_audio_rounded,
                          size: 35,
                          color: Colors.black,
                        ))
                    : state.isConnected
                        ? FloatingActionButton(
                            backgroundColor: Colors.grey[400],
                            onPressed: () => state.isDisconnected
                                ? null
                                : context.read<MotorControllerBloc>().add(
                                    Disconnect(
                                        results: results, list: typesOfBalls)),
                            child: const Icon(
                              Icons.bluetooth_disabled_rounded,
                              color: Colors.black,
                              size: 35,
                            ))
                        : null,
                backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
                body: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 9),
                                child: Text(
                                  'Hi,',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              InkWell(
                                onLongPress: () {
                                  getNameDilog(context, username)
                                      .then((value) async {
                                    if (value != null && value.isNotEmpty) {
                                      await _updateUsername(value);
                                    }
                                  });
                                },
                                child: Text(
                                  username,
                                  style: GoogleFonts.bebasNeue(fontSize: 35),
                                ),
                              ),
                              state.isConnected
                                  ? MyPopUp(
                                      typeOfBall: typesOfBalls,
                                      m1inc: 'l',
                                      m2inc: 'm',
                                      m2dec: 'n',
                                      m1dec: 'o',
                                      reset: 'r',
                                      //intArgument: onsec(),
                                    )
                                  : Container()
                            ],
                          ),
                          SizedBox(
                            child: state.isConnected
                                ? const Icon(
                                    Icons.bluetooth_connected_rounded,
                                    size: 35,
                                    color: Colors.black,
                                  )
                                : state.isDiscovering
                                    ? LoadingAnimationWidget.beat(
                                        color: Colors.grey, size: 30)
                                    : state.isConnecting
                                        ? LoadingAnimationWidget.discreteCircle(
                                            color: Colors.grey, size: 30)
                                        : const Icon(
                                            Icons.bluetooth_disabled_rounded,
                                            size: 35,
                                            color: Colors.black,
                                          ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      state.isDiscovering
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: results.length,
                                itemBuilder: (BuildContext context, index) {
                                  BluetoothDiscoveryResult result =
                                      results[index];
                                  return Card(
                                    color: Colors.grey[400],
                                    child: BluetoothDeviceListEntry(
                                        device: result.device,
                                        rssi: result.rssi,
                                        onTap: () {
                                          state.isloading
                                              ? null
                                              : context
                                                  .read<MotorControllerBloc>()
                                                  .add(
                                                      ConnectToDeviceAndStartListening(
                                                          result.device));
                                          //typesOfBalls[0][2] = true;
                                        }),
                                  );
                                },
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: state.isConnected
                                      ? Colors.grey[200]
                                      : Colors.black38,
                                  borderRadius: BorderRadius.circular(30)),
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Commbutton1(
                                      const Icon(Icons.arrow_upward_rounded),
                                      state.isConnected ? 'i' : null,
                                      context,
                                      state.isConnected
                                          ? Colors.black
                                          : Colors.white),
                                  Commbutton1(
                                      const FaIcon(FontAwesomeIcons.stop),
                                      state.isConnected ? 'j' : null,
                                      context,
                                      state.isConnected
                                          ? Colors.black
                                          : Colors.white),
                                  Commbutton1(
                                      const Icon(Icons.arrow_downward_rounded),
                                      state.isConnected ? 'k' : null,
                                      context,
                                      state.isConnected
                                          ? Colors.black
                                          : Colors.white)
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      state.isConnected
                          ? Container(
                              child: StreamBuilder(
                                  stream: context
                                      .read<MotorControllerBloc>()
                                      .dataStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      log('snaphasdata');
                                      return Text(
                                        snapshot.data!,
                                        style:
                                            GoogleFonts.bebasNeue(fontSize: 15),
                                      );
                                    } else if (snapshot.hasError) {
                                      log('error in snapshot ${snapshot.error}');
                                      return Text(snapshot.error.toString());
                                    } else {
                                      return const Text('ball speed');
                                    }
                                  }))
                          : SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      state.isDiscovering
                          ? const SizedBox()
                          : Expanded(
                              child: ListView(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: typesOfBalls.length,
                                    padding: const EdgeInsets.all(20),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5,
                                            childAspectRatio: 1 / 1.3),
                                    itemBuilder: (context, index) {
                                      return BallBox(
                                        ballnum: state.isConnected ? index : -1,
                                        onChanged: (value) {
                                          if (value && state.isConnected) {
                                            log('coming in side');
                                            context
                                                .read<MotorControllerBloc>()
                                                .add(SendMessage(
                                                    typesOfBalls[index][3]));
                                          }
                                          log('$value');
                                          state.isConnected && value
                                              ? powerSwitchHadChanged(
                                                  value, index)
                                              : null;
                                        },
                                        ballType: typesOfBalls[index][0],
                                        iconPath: typesOfBalls[index][1],
                                        powerOn: typesOfBalls[index][2],
                                      );
                                    },
                                  ),
                                  Center(
                                    child: Text(
                                      'TheBowler',
                                      textAlign: TextAlign.center,
                                      style:
                                          GoogleFonts.bebasNeue(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                )));
          },
        ),
      ),
    );
  }
}
