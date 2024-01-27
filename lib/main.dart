import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motor_controller_esp32/Intro_Screens/intro_screens.dart';
import 'package:motor_controller_esp32/firebase_options.dart';
import 'package:motor_controller_esp32/l10n/l10n.dart';
import 'package:motor_controller_esp32/services/auth/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:localization_i18n_arb/l10n/l10n.dart';

import './MainPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MotorControllerEsp32());
}

class MotorControllerEsp32 extends StatefulWidget {
  const MotorControllerEsp32({super.key});

  // static void setLocale(BuildContext context, Locale newLocale) {
  //   print('inside the main.dart file');
  //   _MotorControllerEsp32State? state =
  //       context.findAncestorStateOfType<_MotorControllerEsp32State>();
  //   state!.setLocale(newLocale);
  //   print('state!.setlocale is done');
  // }

  void setLang(BuildContext context) {
    _MotorControllerEsp32State? state =
        context.findAncestorStateOfType<_MotorControllerEsp32State>();
    state!.setLang();
  }

  @override
  State<MotorControllerEsp32> createState() => _MotorControllerEsp32State();
}

class _MotorControllerEsp32State extends State<MotorControllerEsp32> {
  //Locale _locale = Locale('en', 'US');
  late SharedPreferences prefs;
  bool introDone = false;
  bool lang = false;
  @override
  void initState() {
    langToSet();
    pageToGo();
    super.initState();
  }

  Future<void> pageToGo() async {
    prefs = await SharedPreferences.getInstance();
    introDone = prefs.getBool('introdone') ?? false;
    await prefs.setBool('introdone', true);
    setState(() {});
  }

  Future<void> langToSet() async {
    prefs = await SharedPreferences.getInstance();
    lang = prefs.getBool('lang') ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //locale: _locale,
        locale: Locale(setLocale()),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        debugShowCheckedModeBanner: false,
        home: LoginView()
        // introDone ? MainPage() : const IntroScreens()
        );
  }

  Future<void> setLang() async {
    prefs = await SharedPreferences.getInstance();
    lang = prefs.getBool('lang') ?? false;
    print(lang);
    if (lang) {
      print('lang is true in setlang function');
      await prefs.setBool('lang', false);
    } else {
      print('lang is false in setlang function');
      await prefs.setBool('lang', true);
    }
    lang = prefs.getBool('lang') ?? false;
    print(lang);

    setState(() {});
  }

  Future<bool> retrivelang() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool('lang') ?? false;
  }

  String setLocale() {
    retrivelang().then((retrievedLang) {
      lang = retrievedLang;
    });
    if (lang) {
      print('lang is true in setlocale function');
      return 'hi';
    } else {
      print('lang is false in setlocale funciton');
      return 'en';
    }
  }
}
