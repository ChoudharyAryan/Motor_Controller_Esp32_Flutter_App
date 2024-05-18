import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/enums/action_menu.dart';
import 'package:motor_controller_esp32/main.dart';

import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';
import 'package:motor_controller_esp32/services/auth/bloc/auth_bloc_bloc.dart';
import 'package:motor_controller_esp32/services/auth/views/auth_view.dart';
import 'package:motor_controller_esp32/util/GenericAlertDilog.dart';

class NormalPopUp extends StatelessWidget {
  // final int intArgument;
  final List typeOfBall;
  final String reset;
  NormalPopUp({required this.typeOfBall, required this.reset});

  //String selectedValue = 'Select an option';
  Future<void> _showWarningDialog(
      BuildContext context, String reset, MotorControllerState state) async {
    log('inside the _showWARNINGdIALOG');
    if (state is MotorControllerConnectedAndListening) {
      int? result;
      await ShowMyWarning(context, 'restart').then((value) => result = value);
      if (result == 1) {
        context.read<MotorControllerBloc>().add(SendMessage(reset));
        context
            .read<MotorControllerBloc>()
            .add(Disconnect(results: const [], list: typeOfBall));
      }
      return;
    } else {
      return;
    }
  }

  Future<void> logoutDialog(BuildContext context, String text) async {
    int? logout;
    await ShowMyWarning(context, 'logout').then(
      (value) => logout = value,
    );
    if (logout == 1) {
      context.read<AuthBloc>().add(const AuthEventLogOut());
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const AuthView();
      }), (route) => false);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MotorControllerBloc>(
      create: ((context) => MotorControllerBloc()),
      child: PopupMenuButton<ActionMenu>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.grey[300],
        icon: const Icon(
          Icons.menu_rounded,
        ),
        onSelected: (value) async {
          switch (value) {
            case ActionMenu.language:
              MotorControllerEsp32 motorController =
                  const MotorControllerEsp32();
              motorController.setLang(context);
            case ActionMenu.logout:
              logoutDialog(context, 'logout');
            case ActionMenu.restart:
              _showWarningDialog(
                  context, reset, context.read<MotorControllerBloc>().state);
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: ActionMenu.language,
              child: Text(
                'Language',
                style: GoogleFonts.josefinSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            PopupMenuItem(
              value: ActionMenu.logout,
              child: Text(
                'Logout',
                style: GoogleFonts.josefinSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            PopupMenuItem(
              value: ActionMenu.restart,
              child: Text(
                'Restart',
                style: GoogleFonts.josefinSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ];
        },
      ),
    );
  }
}






  // itemBuilder: ((context) {
        //   return [
        //     PopupMenuItem(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        //         onPressed: () =>
        //             context.read<MotorControllerBloc>().add(SendMessage(inc)),
        //         child: const Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               'increase',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             Icon(
        //               Icons.arrow_upward_rounded,
        //               color: Colors.white,
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //     PopupMenuItem(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        //         onPressed: () =>
        //             context.read<MotorControllerBloc>().add(SendMessage(dec)),
        //         child: const Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               'decrease',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             Icon(
        //               Icons.arrow_upward_rounded,
        //               color: Colors.white,
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //     PopupMenuItem(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.red.shade600),
        //         onPressed: () async {
        //           _showWarningDialog(context, reset);
        //         },
        //         child: const Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               'reset',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             Icon(
        //               Icons.restart_alt_rounded,
        //               color: Colors.white,
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ];
        // }
        // )