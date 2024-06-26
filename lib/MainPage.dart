import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motor_controller_esp32/services/auth/bloc/auth_bloc_bloc.dart';
import 'package:motor_controller_esp32/services/auth/firebase_auth_provider.dart';
import 'package:motor_controller_esp32/util/BluetoothDeviceListEntry.dart';
import 'package:motor_controller_esp32/util/GenericAlertDilog.dart';
import 'package:motor_controller_esp32/util/ball_box.dart';
import 'package:motor_controller_esp32/util/commButton.dart';
import 'package:motor_controller_esp32/util/loading_screen/loading_screen.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_controller_esp32/util/normalPopUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    ['Forward', 'lib/images/stump.png', false, 'i', 'k', 'f'],
    ['Right Swing', 'lib/images/stump.png', false, 'p', 't', 'r'],
    ['Left Swing', 'lib/images/stump.png', false, 'p', 't', 'l'],
  ];
  //List<int> ballswing = [0, 0, 0];

  // ['Normal Fast', 'lib/images/stump.png', false, 'b', 'd', 2],
  // ['Normal Slow', 'lib/images/stump.png', false, 'c', 'e', 3],
  //['Right Spin', 'lib/images/stump.png', false, 'f', 'k', 6],
  // ['Left Spin', 'lib/images/stump.png', false, 'g', 'j', 7],
  // ['Yorker', 'lib/images/stump.png', false, 'h', 'm', 8],
  void powerSwitchHadChanged(int index) {
    // log('power switcch is tweaked');
    setState(() {
      // log('inside setstate of mainpage');
      for (int i = 0; i < typesOfBalls.length; i++) {
        if (typesOfBalls[i][2] == true) {
          typesOfBalls[i][2] = false;
        }
      }
      if (index != -1) {
        // log('about to turn it to true');
        typesOfBalls[index][2] = true;
      }
    });
  }

  String? data;
  String? speed;
  bool ballfeeder = false;

  @override
  void initState() {
    _loadUserName();
    //_getSwingLevel();
    //setFeeder();
    swingLevel = 0;
    fLevel = 0;
    super.initState();
  }

  // Future<void> _getSwingLevel() async {
  //   pref = await SharedPreferences.getInstance();
  //   ballswing[0] = pref.getInt('b1') ?? 0;
  //   ballswing[1] = pref.getInt('b2') ?? 0;
  //   ballswing[2] = pref.getInt('b3') ?? 0;
  // }
  int swingLevel = 0;
  int fLevel = 0;
  Future<void> _loadUserName() async {
    pref = await SharedPreferences.getInstance();
    username = pref.getString('username') ?? 'user';
    setState(() {});
  }

  Future<void> _updateUsername(String newUsername) async {
    await pref.setString('username', newUsername);
    _loadUserName();
  }

  // void _startTimer(BuildContext context) async {
  //   while (context.read<MotorControllerBloc>().state ==
  //       MotorControllerDiscovering) {
  //     log('NOWWWWWWWWWWWWWWWWWWWWW');
  //     setState(() {});
  //   }
  // log('kkkkkkkkkkkkkkkkkkkkk');
  // log(context.read<MotorControllerBloc>().state.toString());
  // BlocListener<MotorControllerBloc, MotorControllerState>(
  //     listener: (context, state) {
  //   log('GGGGGGGGGGGGGGGGGGGGGGG');

  //   if (state is MotorControllerDiscovering) {
  //     Timer.periodic(const Duration(seconds: 5), (timer) {
  //       log('gona call the setstate');
  //       setState(() {});

  //       //_startTimer();
  //     });
  //   } else {
  //     log('gona return from _startTimer function');
  //     return;
  //   }
  // });
  // }

  void updateData(BuildContext context) {
    //log('inside the updateData function');
    data = context.read<MotorControllerBloc>().state.data;
    //log('Updated Data is : $data');
    if (data != null) {
      //log('dataStream is $data');
      RegExp regExpF = RegExp(r'F(\d+)\*');
      RegExp regExpR = RegExp(r'R(\d+)[#*]');
      RegExp regExpN = RegExp(r'N(\d+)\*');
      RegExp regExpS = RegExp(r'S([^*]+)\*');
      RegExp regExpM = RegExp(r'M([^*]+)\*');
      RegExp regExpC = RegExp(r'C([^*]+)\*');
      Match? matchC = regExpC.firstMatch(data!);
      Match? matchS = regExpS.firstMatch(data!);
      Match? matchM = regExpM.firstMatch(data!);
      Match? matchN = regExpN.firstMatch(data!);
      Match? matchF = regExpF.firstMatch(data!);
      Match? matchR = regExpR.firstMatch(data!);
      if (matchC != null) {
        String valueCString = matchC.group(1)!;
        setState(() {
          fLevel = int.parse(valueCString);
        });
      } else {
        log('FUCK THE C BLOK');
      }
      if (matchM != null) {
        String valueMString = matchM.group(1)!;
        if (valueMString == "r_swing") {
          powerSwitchHadChanged(1);
        } else if (valueMString == "l_swing") {
          powerSwitchHadChanged(2);
        } else {
          powerSwitchHadChanged(0);
        }
      } else {
        //print("No match found for M.");
      }
      if (matchS != null) {
        String valueSString = matchS.group(1)!;
        setState(() {
          speed = valueSString;
        });

        // print("The string value after S is: $valueSString");
      } else {
        //print("No match found for S.");
      }
      if (matchN != null) {
        String value = matchN.group(1)!;
        setState(() {
          swingLevel = int.parse(value);
        });

        //log("The value after N is: $value");
      } else {
        //print("No match found.");
      }
      if (matchF != null) {
        String valueFString = matchF.group(1)!;
        if (valueFString == '0') {
          setState(() {
            ballfeeder = false;
          });
        } else {
          setState(() {
            ballfeeder = true;
          });
        }
        //print("The integer value after F is: $valueF");
      } else {
        //print("No match found for F.");
      }
      if (matchR != null) {
        String valueRString = matchR.group(1)!;

        setState(() {
          feeder = int.parse(valueRString);
        });

        //print("The integer value after R is: $valueR");
      } else {
        //print("No match found for R.");
      }
    }
  }

  // void checkConnection(BuildContext context) {}

  // void _startTimeragain(BuildContext context) async {
  //   BlocListener<MotorControllerBloc, MotorControllerState>(
  //       listener: (context, state) {
  //     if (state is MotorControllerDiscovering) {
  //       Timer.periodic(const Duration(seconds: 3), (timer) {
  //         log('gona call the setstate');
  //         setState(() {});

  //         //_startTimer();
  //       });
  //     } else {
  //       //log('gona return from _startTimer function');
  //       return;
  //     }
  //   });
  //   _startTimer(context);
  // }

  int feeder = 0;
  bool isConnected = false;

  // Future<void> setFeeder() async {
  //   pref = await SharedPreferences.getInstance();
  //   feeder = pref.getInt('feeder') ?? 0;
  // }
  Timer? _discoveryTimer;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MotorControllerBloc>(
          create: (context) => MotorControllerBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
        ),
      ],
      child: BlocConsumer<MotorControllerBloc, MotorControllerState>(
        listener: (context, state) async {
          // _discoveryTimer = Timer.periodic(Duration(seconds: 3), (timer) {
          //   if (state.isDiscovering) {
          //     log("SADDLY THE STATE ISDISCOVERING");
          //   } else {
          //     log("AND NOW IT IS NOT");
          //     _discoveryTimer?.cancel();
          //     _discoveryTimer = null;
          //   }
          // });

          if (state.isloading) {
            LoadingScreen().show(context: context, text: state.loadingText);
          } else {
            LoadingScreen().hide();
          }
          if (state is MotorControllerException) {
            ShowMyDilog(context, state.string);
          } else if (state.string != null) {
            ShowErrorSnackBar(context, state.string!);
          }
          if (state is MotorControllerDiscovering) {
            //setState(() {});
            isConnected = false;
            log('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFff');
            _startPeriodicTimer(state);
            //setState(() {});
            //_discoveryTimer =

            // Timer.periodic(const Duration(seconds: 3), (timer) {
            //   log('gona call the setstate bitchess');
            //   //log(context.read<MotorControllerBloc>().state.toString());
            //   if (state.isDiscovering) {
            //     log(context.read<MotorControllerBloc>().state.toString());
            //     //log('WHYYYYYYYYYYYYYYYYYYYYY');
            //     state.isDiscovering ? log("WHY THOUGH") : log("OK THEN");
            //     setState(() {});
            //   }
            // });

            // _startTimer(context);
            // _startTimeragain(context);
          } else {
            _cancelPeriodicTimer();
          }
          if (state is MotorControllerConnectedAndListening) {
            //log(state.toString());
            //log('this is the state now');
            //_discoveryTimer?.cancel();

            isConnected = true;
            updateData(context);
            //typesOfBalls[0][2] = true;
            // context.read<MotorControllerBloc>().add(
            //       SendMessage('f${ballswing[0]}#'),
            //     );
          } else {
            isConnected = false;
          }
        },
        builder: (context, state) {
          return Scaffold(
              floatingActionButton: !state.isDiscovering &&
                      !state.isConnecting &&
                      !state.isConnected
                  ? FloatingActionButton(
                      backgroundColor: Colors.grey[300],
                      onPressed: () {
                        log('start Discovery*********');
                        context
                            .read<MotorControllerBloc>()
                            .add(StartDiscovery(results, context));
                      },
                      child: const Icon(
                        Icons.bluetooth_audio_rounded,
                        size: 35,
                        color: Colors.black,
                      ))
                  : state.isConnected
                      ? FloatingActionButton(
                          backgroundColor: Colors.grey[400],
                          onPressed: () {
                            state.isDisconnected
                                ? null
                                : context.read<MotorControllerBloc>().add(
                                    Disconnect(
                                        results: results, list: typesOfBalls));
                            swingLevel = 0;
                            feeder = 0;
                            ballfeeder = false;
                          },
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
                            Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: Text(
                                  AppLocalizations.of(context)!.hi,
                                  style: const TextStyle(fontSize: 20),
                                )),
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
                          ],
                        ),
                        Row(
                          children: [
                            NormalPopUp(
                              typeOfBall: typesOfBalls,
                              reset: 'a#',
                              //intArgument: onsec(),
                            ),
                            SizedBox(
                                child: state.isConnected
                                    ? null
                                    : state.isDiscovering
                                        ? LoadingAnimationWidget.beat(
                                            color: Colors.grey, size: 30)
                                        : state.isConnecting
                                            ? LoadingAnimationWidget
                                                .discreteCircle(
                                                    color: Colors.grey,
                                                    size: 30)
                                            : null),
                          ],
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
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(15)),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Commbutton1(
                                  const Icon(Icons.arrow_upward_rounded),
                                  state.isConnected ? 'i#' : null,
                                  context,
                                  state.isConnected
                                      ? Colors.black
                                      : Colors.white,
                                  () {},
                                  typesOfBalls,
                                ),
                                Commbutton1(
                                    const FaIcon(FontAwesomeIcons.stop),
                                    state.isConnected ? 'j#' : null,
                                    context,
                                    state.isConnected
                                        ? Colors.black
                                        : Colors.white, () {
                                  powerSwitchHadChanged(-1);
                                }, typesOfBalls),
                                Commbutton1(
                                    const Icon(Icons.arrow_downward_rounded),
                                    state.isConnected ? 'k#' : null,
                                    context,
                                    state.isConnected
                                        ? Colors.black
                                        : Colors.white,
                                    () {},
                                    typesOfBalls)
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    state.isConnected
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () async {
                                        if (feeder < 10) {
                                          ++feeder;
                                          context
                                              .read<MotorControllerBloc>()
                                              .add(
                                                SendMessage(
                                                    'x$feeder#', typesOfBalls),
                                              );
                                          await pref.setInt('feeder', feeder);
                                          setState(() {});
                                        }
                                      },
                                      child: const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () async {
                                        if (feeder > 0) {
                                          --feeder;
                                          context
                                              .read<MotorControllerBloc>()
                                              .add(
                                                SendMessage(
                                                    'x$feeder#', typesOfBalls),
                                              );
                                          await pref.setInt('feeder', feeder);
                                          setState(() {});
                                        }
                                      },
                                      child: const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(15),
                                        // border: Border.all(
                                        //   color: Colors.black,
                                        //   width: 2,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade500,
                                            offset: const Offset(4.0, 4.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0,
                                          ),
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4.0, -4.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0,
                                          )
                                        ],
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                            stream: context
                                                .read<MotorControllerBloc>()
                                                .dataStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                // return Text(snapshot.data!,
                                                //     style:
                                                //         GoogleFonts.bebasNeue(
                                                //             fontSize: 15));
                                                String fspeed = snapshot.data!;
                                                RegExp regExps =
                                                    RegExp(r'S([^*]+)\*');
                                                Match? matchs =
                                                    regExps.firstMatch(fspeed);
                                                String valueS = matchs != null
                                                    ? matchs.group(1)!
                                                    : 'No match found';
                                                log("this is the values : $valueS");
                                                return Text(
                                                  "Speed : $valueS",
                                                  style: GoogleFonts.bebasNeue(
                                                      fontSize: 18),
                                                );
                                              } else if (snapshot.hasError) {
                                                //log('error in snapshot //${snapshot.error}');
                                                return Text(
                                                    snapshot.error.toString());
                                              } else {
                                                return Text(
                                                  AppLocalizations.of(context)!
                                                      .ballspeed,
                                                  style: GoogleFonts.bebasNeue(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              }
                                            }),
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<MotorControllerBloc>().add(
                                            SendMessage('b', typesOfBalls),
                                          );
                                      setState(() {
                                        ballfeeder = !ballfeeder;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: ballfeeder
                                            ? Colors.black
                                            : Colors.grey[300],
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade500,
                                            offset: const Offset(4.0, 4.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0,
                                          ),
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4.0, -4.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .feeder,
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 18,
                                                  color: ballfeeder
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                feeder.toString(),
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 18,
                                                  color: ballfeeder
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          Center(
                                            child: Icon(
                                              Icons.circle_rounded,
                                              size: 35,
                                              color: ballfeeder
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(),
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
                                          crossAxisCount: 1,
                                          //crossAxisSpacing: 5,
                                          childAspectRatio: 1 / 0.4),
                                  itemBuilder: (context, index) {
                                    return BallBox(
                                      typeOfBalls: typesOfBalls,
                                      fLevel: fLevel,
                                      swingLevel: swingLevel,
                                      setSwing: (val) {
                                        log('Currently the Swing Level is : $swingLevel');
                                        swingLevel = val;
                                        log('And Now the Swing Level is : $swingLevel');
                                        log('ALso this is the val $val');
                                      },
                                      onTap: () {
                                        /// log('ballbox no . ${typesOfBalls[index][0]} tapped on!');
                                        context.read<MotorControllerBloc>().add(
                                            SendMessage(
                                                '${typesOfBalls[index][5]}',
                                                typesOfBalls));
                                        //log(state.toString());
                                        // log(isConnected.toString());
                                        //log(typesOfBalls[index][2].toString());
                                        isConnected
                                            ? powerSwitchHadChanged(index)
                                            : null;
                                        //log(typesOfBalls[index][2].toString());
                                      },
                                      inc: typesOfBalls[index][3],
                                      dec: typesOfBalls[index][4],
                                      // swingLevel: ballswing[index],
                                      ballType: ballname(index),
                                      iconPath: typesOfBalls[index][1],
                                      powerOn: typesOfBalls[index][2],
                                    );
                                  },
                                ),
                                Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.thebowler,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.bebasNeue(fontSize: 25),
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
    );
  }

  String ballname(int index) {
    if (index == 0) {
      return 'forward';
      //AppLocalizations.of(context)!.forward;
    } else if (index == 1) {
      return 'rightswing';
      //AppLocalizations.of(context)!.rightswing;
    } else if (index == 2) {
      return 'leftswing';
      //AppLocalizations.of(context)!.leftswing;
    } else {
      return '';
    }
  }

  // Future<void> setswing(int index, int val) async {
  //   if (index == 0) {
  //     await pref.setInt('b1', val);
  //   } else if (index == 1) {
  //     await pref.setInt('b2', val);
  //   } else if (index == 2) {
  //     await pref.setInt('b3', val);
  //   }
  // }
  void _startPeriodicTimer(MotorControllerState state) {
    // Cancel any existing timer
    _cancelPeriodicTimer();

    // Start a new periodic timer
    _discoveryTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (state.isDiscovering) {
        log("SADDLY THE STATE ISDISCOVERING");
        setState(() {});
      } else {
        log("AND NOW IT IS NOT");
        _cancelPeriodicTimer();
      }
    });
  }

  void _cancelPeriodicTimer() {
    if (_discoveryTimer != null) {
      _discoveryTimer?.cancel();
      _discoveryTimer = null;
    }
  }
}
