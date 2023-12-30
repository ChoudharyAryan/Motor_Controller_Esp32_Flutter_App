import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen1 extends StatelessWidget {
  const OnBoardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Lottie.asset('lib/animations/anime2.json'),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                    pause: const Duration(seconds: 2),
                    animatedTexts: [
                      TypewriterAnimatedText('TAKE CHARGE OF THE BOWLER_',
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.sourceCodePro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TypewriterAnimatedText(
                          'PLAY YOUR WAY, POSSIBILITIES ARE ENDLESS!',
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.sourceCodePro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TypewriterAnimatedText(
                          'A SEAMLESS EXPERIENCE AWAITS YOU.',
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.sourceCodePro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
