//import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';
import 'package:motor_controller_esp32/util/GenericAlertDilog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPopUp extends StatelessWidget {
  // final int intArgument;
  final List typeOfBall;
  final String m1inc;
  final String m2inc;
  final String m1dec;
  final String m2dec;
  final String reset;
  MyPopUp(
      {required this.typeOfBall,
      required this.m1inc,
      required this.m2inc,
      required this.m1dec,
      required this.m2dec,
      required this.reset});

  // motor1up() {
  //   String ans = '';
  //   for (int i = 0; i < 5; i++) {
  //     if (i == intArgument) {
  //       ans = i.toString();
  //     }
  //   }
  //   return ans;
  // }

  // motor2up() {
  //   String ans = '';
  //   for (int i = 0; i < 5; i++) {
  //     if (i == intArgument) {
  //       i += 4;
  //       ans = i.toString();
  //     }
  //   }
  //   return ans;
  // }

  // motor1down() {
  //   String ans = '';
  //   for (int i = 0; i < 5; i++) {
  //     if (i == intArgument) {
  //       if (i == 0) {
  //         ans = 'A';
  //       } else if (i == 1) {
  //         ans = 'B';
  //       } else if (i == 2) {
  //         ans = 'C';
  //       } else if (i == 3) {
  //         ans = 'D';
  //       } else {
  //         ans = 'E';
  //       }
  //     }
  //   }
  //   return ans;
  // }

  // motor2down() {
  //   String ans = '';
  //   for (int i = 0; i < 5; i++) {
  //     if (i == intArgument) {
  //       if (i == 0) {
  //         ans = 'F';
  //       } else if (i == 1) {
  //         ans = 'G';
  //       } else if (i == 2) {
  //         ans = 'H';
  //       } else if (i == 3) {
  //         ans = 'I';
  //       } else {
  //         ans = 'J';
  //       }
  //     }
  //   }
  //   return ans;
  // }

  String selectedValue = 'Select an option';
  Future<void> _showWarningDialog(BuildContext context, String reset) async {
    int? result;
    await ShowMyWarning(context).then((value) => result = value);
    if (result == 1) {
      context.read<MotorControllerBloc>().add(SendMessage(reset));
      context
          .read<MotorControllerBloc>()
          .add(Disconnect(results: const [], list: typeOfBall));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.grey[400],
        icon: const Icon(
          Icons.menu_rounded,
        ),
        itemBuilder: ((context) {
          return [
            PopupMenuItem(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () =>
                    context.read<MotorControllerBloc>().add(SendMessage(m1inc)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.motor1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () =>
                    context.read<MotorControllerBloc>().add(SendMessage(m2inc)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.motor2,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () =>
                    context.read<MotorControllerBloc>().add(SendMessage(m1dec)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.motor1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () =>
                    context.read<MotorControllerBloc>().add(SendMessage(m2dec)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.motor2,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600),
                onPressed: () async {
                  _showWarningDialog(context, reset);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.restart,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.restart_alt_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ];
        }));
  }
}
