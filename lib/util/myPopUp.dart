import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';

class MyPopUp extends StatelessWidget {
  void Function(dynamic)? onChanged;
  String selectedValue = 'Select an option';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.grey[400],
        icon: Icon(
          Icons.menu_rounded,
        ),
        itemBuilder: ((context) {
          return [
            PopupMenuItem(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () => context
                    .read<MotorControllerBloc>()
                    .add(const SendMessage('l')),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Motor1',
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
                onPressed: () => context
                    .read<MotorControllerBloc>()
                    .add(const SendMessage('m')),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Motor2',
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
                onPressed: () => context
                    .read<MotorControllerBloc>()
                    .add(const SendMessage('n')),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Motor1',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
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
                onPressed: () => context
                    .read<MotorControllerBloc>()
                    .add(const SendMessage('o')),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Motor2',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_downward_rounded,
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
