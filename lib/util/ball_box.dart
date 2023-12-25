import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BallBox extends StatelessWidget {
  final String ballType;
  final String iconPath;
  final bool powerOn;
  final onChanged;
  BallBox(
      {super.key,
      required this.ballType,
      required this.onChanged,
      required this.iconPath,
      required this.powerOn});

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
            Image.asset(
              iconPath,
              height: 50,
              color: powerOn ? Colors.white : Colors.black,
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
