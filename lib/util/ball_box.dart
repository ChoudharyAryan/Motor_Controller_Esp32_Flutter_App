import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motor_controller_esp32/util/myPopUp.dart';
import 'package:motor_controller_esp32/util/normalPopUp.dart';

class BallBox extends StatelessWidget {
  final String ballType;
  final String iconPath;
  final bool powerOn;
  final onChanged;
  final ballnum;
  BallBox(
      {super.key,
      required this.ballType,
      required this.onChanged,
      required this.iconPath,
      required this.powerOn,
      required this.ballnum});

  NormalPopUp normalballpopup() {
    print('normal popup');
    return NormalPopUp(
      typeOfBall: const [],
      inc: 'P',
      dec: 'Q',
      reset: 'R',
    );
  }

  NormalPopUp normalfballpopup() {
    return NormalPopUp(
      typeOfBall: const [],
      inc: 'S',
      dec: 'T',
      reset: 'U',
    );
  }

  NormalPopUp normalsballpopup() {
    return NormalPopUp(
      typeOfBall: const [],
      inc: 'V',
      dec: 'W',
      reset: 'X',
    );
  }

  MyPopUp rightswpopup() {
    return MyPopUp(
        typeOfBall: const [],
        m1inc: 'p',
        m2inc: 'q',
        m1dec: 's',
        m2dec: 't',
        reset: 'u');
  }

  MyPopUp leftswpopup() {
    print('inside the leftswpopup function');
    return MyPopUp(
        typeOfBall: const [],
        m1inc: 'v',
        m2inc: 'w',
        m1dec: 'x',
        m2dec: 'y',
        reset: 'z');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: powerOn ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onLongPress: () {
                print('called the long press button');
                if (ballnum == 0) {
                  print('ball num is 0');
                  normalballpopup();
                } else if (ballnum == 1) {
                  normalfballpopup();
                } else if (ballnum == 2) {
                  normalsballpopup();
                } else if (ballnum == 3) {
                  rightswpopup();
                } else if (ballnum == 4) {
                  print('inside the leftswing ball');
                  leftswpopup();
                } else {
                  print('simr problem');
                  null;
                }
              },
              child: Image.asset(
                iconPath,
                height: 50,
                color: powerOn ? Colors.white : Colors.black,
              ),
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    ballType,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: powerOn ? Colors.white : Colors.black),
                  ),
                )),
                Transform.rotate(
                    angle: pi / 2,
                    child:
                        CupertinoSwitch(value: powerOn, onChanged: onChanged))
              ],
            )
          ],
        ),
      ),
    );
  }
}
