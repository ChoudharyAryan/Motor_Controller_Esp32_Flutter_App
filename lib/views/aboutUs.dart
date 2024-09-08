import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class aboutUs extends StatefulWidget {
  const aboutUs({super.key});

  @override
  State<aboutUs> createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('about',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 80, fontWeight: FontWeight.bold)),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.bebasNeue(
                              color: Colors.black,
                              fontSize: 80,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(text: 'US'),
                            TextSpan(
                              text: '.',
                              style: GoogleFonts.bebasNeue(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Container(
                  //     //height: MediaQuery.sizeOf(context).height * 0.5,
                  //     width: MediaQuery.sizeOf(context).width * 0.4,
                  //     child: Expanded(
                  //         child: Image.asset('lib/images/cricket.png'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
