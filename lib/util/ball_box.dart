import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';

class BallBox extends StatefulWidget {
  final String inc;
  final String dec;
  List typeOfBalls;
  int fLevel;

  final String ballType;
  int swingLevel;
  final bool powerOn;
  final String iconPath;
  final VoidCallback onTap;
  final setSwing;
  BallBox(
      {super.key,
      required this.inc,
      required this.fLevel,
      required this.typeOfBalls,
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
  late int supSwingLevel;
  //late int fLevel;
  //late int swingLevel;
  late final setSwing;
  late VoidCallback onTap;
  late String iconPath;
  // late SharedPreferences pref;
  //double swingLevel = 0;
  @override
  void initState() {
    super.initState();
    inc = widget.inc;
    supSwingLevel = widget.swingLevel;
    setSwing = widget.setSwing;
    //swingLevel = widget.swingLevel;
    //fLevel = widget.fLevel;
    onTap = widget.onTap;
    dec = widget.dec;
    ballType = widget.ballType;
    powerOn = widget.powerOn;
    iconPath = widget.iconPath;
    //_getSwingLevel();
  }

  //int swingLevel = 0;

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
                width: ballType == 'forward'
                    ? widget.fLevel /
                        17 *
                        (MediaQuery.of(context).size.width * 0.85)
                    : widget.swingLevel /
                        17 *
                        (MediaQuery.of(context).size.width * 0.85),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ballType == 'forward'
                          ? AppLocalizations.of(context)!.forward
                          : ballType == 'rightswing'
                              ? AppLocalizations.of(context)!.rightswing
                              : ballType == 'leftswing'
                                  ? AppLocalizations.of(context)!.leftswing
                                  : '',
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
                                    SendMessage('$inc#', widget.typeOfBalls),
                                  );
                              setState(() {
                                if (widget.fLevel < 17) {
                                  if (ballType != 'Forward') {
                                    widget.swingLevel++;
                                    setSwing(widget.swingLevel);
                                  }
                                  widget.fLevel++;
                                }
                              });
                              //setSwing(swingLevel);
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
                                    SendMessage('$dec#', widget.typeOfBalls),
                                  );
                              setState(() {
                                if (widget.fLevel > 0) {
                                  if (ballType != 'Forward') {
                                    widget.swingLevel--;
                                    setSwing(widget.swingLevel);
                                  }
                                  widget.fLevel--;
                                }
                              });
                              //setSwing(swingLevel);
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
