import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen2 extends StatelessWidget {
  const OnBoardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Lottie.asset('lib/animations/anime.json'),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                    pause: const Duration(seconds: 2),
                    animatedTexts: [
                      TypewriterAnimatedText('SEARCHING FOR DEVICES',
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.sourceCodePro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TypewriterAnimatedText('CONNECTING TO DEVICE...',
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
