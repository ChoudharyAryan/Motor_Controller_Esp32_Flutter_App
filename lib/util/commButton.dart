import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';

CupertinoButton Commbutton1(
    child, onPressed, BuildContext context, Color color) {
  return CupertinoButton(
      borderRadius: BorderRadius.circular(25),
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: child,
      onPressed: () => onPressed != null
          ? context.read<MotorControllerBloc>().add(SendMessage(onPressed))
          : null);
}
