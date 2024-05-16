import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> ShowMyDilog(BuildContext context, String content) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(
          content,
          style: GoogleFonts.bebasNeue(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
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
    content: Text(
      Message.toUpperCase(),
      textAlign: TextAlign.center,
      // style: const TextStyle(
      //     fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
      style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.black),
    ),
    backgroundColor: Colors.grey[300],
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
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              labelText: AppLocalizations.of(context)!.eyn,
              labelStyle: GoogleFonts.bebasNeue(
                fontSize: 20,
                color: Colors.black,
              )),
        ),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.done,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(_texteditingcontroller.text);
            },
          ),
        ],
      );
    },
  );
}

Future<int?> ShowMyWarning(BuildContext context, String text) async {
  return showDialog<int?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[300],
        title: Text(
          AppLocalizations.of(context)!.warning,
          style: GoogleFonts.bebasNeue(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        content: text == 'restart'
            ? Text(
                AppLocalizations.of(context)!.restartwarning,
                style: GoogleFonts.radioCanada(
                  fontSize: 18,
                  color: Colors.black,
                ),
              )
            : Text(
                'Are you sure you want to log out?',
                style: GoogleFonts.radioCanada(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: GoogleFonts.bebasNeue(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          ),
          TextButton(
            child: Text(
              'cancel',
              style: GoogleFonts.bebasNeue(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
        ],
      );
    },
  );
}
