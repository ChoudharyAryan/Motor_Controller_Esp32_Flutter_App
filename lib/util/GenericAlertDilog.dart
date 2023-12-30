import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/motor_controller_bloc/motor_controller_bloc.dart';

Future<void> ShowMyDilog(BuildContext context, String content) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('error occured'),
        content: Text('$content'),
        actions: <Widget>[
          TextButton(
            child: const Text('close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void ShowErrorSnackBar(BuildContext context, String Message) {
  final snackBar = SnackBar(
    content: Text(Message),
    backgroundColor: Colors.deepPurple,
    duration: const Duration(seconds: 3),
    width: 280.0,
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<String?> getNameDilog(
    BuildContext context, String? Currentusername) async {
  TextEditingController _texteditingcontroller = TextEditingController();
  return showDialog<String?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text(
        //   'your name please...',
        //   style: GoogleFonts.bebasNeue(fontSize: 20),
        // ),
        //backgroundColor: Colors.grey[300],
        content: TextField(
          maxLength: 12,
          controller: _texteditingcontroller,
          autocorrect: false,
          decoration: InputDecoration(
              fillColor: Colors.grey.shade300,
              filled: true,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              labelText: 'enter your name',
              labelStyle: GoogleFonts.bebasNeue(fontSize: 20)),
        ),
        actions: [
          TextButton(
            child: const Text('done'),
            onPressed: () {
              Navigator.of(context).pop(_texteditingcontroller.text);
            },
          ),
        ],
      );
    },
  );
}

Future<int?> ShowMyWarning(BuildContext context) async {
  return showDialog<int?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('warning'),
        content: const Text(
            'you are restarting The Bowler you will be disconnected and have reconnect to the device '),
        actions: <Widget>[
          TextButton(
            child: const Text('confirm'),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          ),
          TextButton(
            child: const FaIcon(FontAwesomeIcons.ban),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
        ],
      );
    },
  );
}
