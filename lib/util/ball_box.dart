import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';

class BallBox extends StatefulWidget {
  final String inc;
  final String dec;
  final String ballType;
  int swingLevel;
  final bool powerOn;
  final String iconPath;
  final VoidCallback onTap;
  final setSwing;
  BallBox(
      {super.key,
      required this.inc,
      required this.swingLevel,
      required this.setSwing,
      required this.dec,
      required this.onTap,
      required this.ballType,
      required this.powerOn,
      required this.iconPath});

  @override
  State<BallBox> createState() => _BallBoxState();
}

class _BallBoxState extends State<BallBox> {
  late String inc;
  late String ballType;
  late String dec;
  late bool powerOn;
  late int swingLevel;
  late final setSwing;
  late VoidCallback onTap;
  late String iconPath;
  // late SharedPreferences pref;
  //double swingLevel = 0;
  @override
  void initState() {
    super.initState();
    inc = widget.inc;
    setSwing = widget.setSwing;
    swingLevel = widget.swingLevel;
    onTap = widget.onTap;
    dec = widget.dec;
    ballType = widget.ballType;
    powerOn = widget.powerOn;
    iconPath = widget.iconPath;
    //_getSwingLevel();
  }

  // Future<void> _getSwingLevel() async {
  //   pref = await SharedPreferences.getInstance();
  //   swingLevel = pref.getDouble('swingLevel') ?? 0;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[300],
              border: widget.powerOn
                  ? Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                  : null,
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
              ]),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                decoration: BoxDecoration(
                  color: widget.powerOn ? Colors.lightGreen : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: swingLevel /
                    17 *
                    (MediaQuery.of(context).size.width * 0.85),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ballType,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            if (widget.powerOn) {
                              log('increase button pressed');
                              context.read<MotorControllerBloc>().add(
                                    SendMessage('$inc$swingLevel#'),
                                  );
                              setState(() {
                                if (swingLevel < 17) {
                                  swingLevel++;
                                }
                              });
                              setSwing(swingLevel);
                              // pref.setDouble('swingLevel', swingLevel);
                            } else {
                              log('power in not on');
                              null;
                            }
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.arrowUp,
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
                          onPressed: () {
                            if (widget.powerOn) {
                              context.read<MotorControllerBloc>().add(
                                    SendMessage('$dec$swingLevel#'),
                                  );
                              setState(() {
                                if (swingLevel > 0) {
                                  swingLevel--;
                                }
                              });
                              setSwing(swingLevel);
                              //pref.setDouble('swingLevel', swingLevel);
                            } else {
                              log('poweron is nott on');
                              null;
                            }
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.arrowDown,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class BallBox extends StatelessWidget {
//   final String ballType;
//   final String iconPath;
//   final bool powerOn;
//   final onChanged;
//   final BuildContext context;
//   final ballnum;
//   BallBox(
//       {super.key,
//       required this.ballType,
//       required this.context,
//       required this.onChanged,
//       required this.iconPath,
//       required this.powerOn,
//       required this.ballnum});

//   NormalPopUp normalballpopup() {
//     print('normal popup');
//     return NormalPopUp(
//       typeOfBall: const [],
//       // inc: 'P',
//       // dec: 'Q',
//       reset: 'R',
//     );
//   }

//   NormalPopUp normalfballpopup() {
//     return NormalPopUp(
//       typeOfBall: const [],
//       // inc: 'S',
//       // dec: 'T',
//       reset: 'U',
//     );
//   }

//   NormalPopUp normalsballpopup() {
//     return NormalPopUp(
//       typeOfBall: const [],
//       // inc: 'V',
//       // dec: 'W',
//       reset: 'X',
//     );
//   }

//   // MyPopUp rightswpopup() {
//   //   return MyPopUp(
//   //       typeOfBall: const [],
//   //       m1inc: 'p',
//   //       m2inc: 'q',
//   //       m1dec: 's',
//   //       m2dec: 't',
//   //       reset: 'u');
//   // }

//   void leftswpopup(BuildContext context) {
//     print('inside the leftswpopup function');
//     // showDialog(
//     //     context: context,
//     //     builder: (BuildContext context) {
//     //       return MyPopUp(
//     //           typeOfBall: const [],
//     //           m1inc: 'v',
//     //           m2inc: 'w',
//     //           m1dec: 'x',
//     //           m2dec: 'y',
//     //           reset: 'z');
//     //     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5),
//       child: Container(
//         decoration: BoxDecoration(
//             color: powerOn ? Colors.grey[900] : Colors.grey[200],
//             borderRadius: BorderRadius.circular(24)),
//         padding: const EdgeInsets.symmetric(vertical: 25),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 print('called the long press button');
//                 if (ballnum == 0) {
//                   print('ball num is 0');
//                   normalballpopup();
//                 } else if (ballnum == 1) {
//                   normalfballpopup();
//                 } else if (ballnum == 2) {
//                   normalsballpopup();
//                 } else if (ballnum == 3) {
//                   // rightswpopup();
//                 } else if (ballnum == 4) {
//                   print('inside the leftswing ball');
//                   leftswpopup(context);
//                 } else {
//                   print('simr problem');
//                   null;
//                 }
//               },
//               child: Image.asset(
//                 iconPath,
//                 height: 50,
//                 color: powerOn ? Colors.white : Colors.black,
//               ),
//             ),
//             Row(
//               //mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.only(left: 5),
//                   child: Text(
//                     ballType,
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 18,
//                         color: powerOn ? Colors.white : Colors.black),
//                   ),
//                 )),
//                 Transform.rotate(
//                     angle: pi / 2,
//                     child: CupertinoSwitch(
//                         value: powerOn,
//                         onChanged: onChanged != null
//                             ? (value) => onChanged(value)
//                             : null))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
