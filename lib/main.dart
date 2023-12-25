import 'package:flutter/material.dart';
import 'package:motor_controller_esp32/Intro_Screens/intro_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './MainPage.dart';

void main() => runApp(const MotorControllerEsp32());

class MotorControllerEsp32 extends StatefulWidget {
  const MotorControllerEsp32({super.key});

  @override
  State<MotorControllerEsp32> createState() => _MotorControllerEsp32State();
}

class _MotorControllerEsp32State extends State<MotorControllerEsp32> {
  late SharedPreferences prefs;
  bool introDone = false;
  @override
  void initState() {
    pageToGo();
    super.initState();
  }

  Future<void> pageToGo() async {
    prefs = await SharedPreferences.getInstance();
    introDone = prefs.getBool('introdone') ?? false;
    await prefs.setBool('introdone', true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: introDone ? MainPage() : const IntroScreens());
  }
}
