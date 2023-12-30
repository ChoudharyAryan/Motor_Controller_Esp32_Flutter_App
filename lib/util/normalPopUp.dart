//import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';
import 'package:motor_controller_esp32/util/GenericAlertDilog.dart';

class NormalPopUp extends StatelessWidget {
  // final int intArgument;
  final List typeOfBall;
  final String inc;
  final String dec;
  final String reset;
  NormalPopUp(
      {required this.typeOfBall,
      required this.inc,
      required this.dec,
      required this.reset});

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
                    context.read<MotorControllerBloc>().add(SendMessage(inc)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'increase',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
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
                    context.read<MotorControllerBloc>().add(SendMessage(dec)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'decrease',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_upward_rounded,
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'reset',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
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
