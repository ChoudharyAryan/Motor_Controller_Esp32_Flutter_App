import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen3 extends StatelessWidget {
  const OnBoardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Lottie.asset('lib/animations/anime3.json',
                  height: 250, width: 250),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                    pause: const Duration(seconds: 2),
                    animatedTexts: [
                      TypewriterAnimatedText('SELECT BOWLING TYPE',
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.sourceCodePro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TypewriterAnimatedText('PLAY TO YOUR HEARTS CONTENT',
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.sourceCodePro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
