import 'package:flutter/material.dart';

import './MainPage.dart';

void main() => runApp(const MotorControllerEsp32());

class MotorControllerEsp32 extends StatefulWidget {
  const MotorControllerEsp32({super.key});

  @override
  State<MotorControllerEsp32> createState() => _MotorControllerEsp32State();
}

class _MotorControllerEsp32State extends State<MotorControllerEsp32> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}
