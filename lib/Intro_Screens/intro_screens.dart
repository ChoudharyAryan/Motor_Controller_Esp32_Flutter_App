import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_controller_esp32/MainPage.dart';
import 'package:motor_controller_esp32/Intro_Screens/onboarding_screens_1.dart';
import 'package:motor_controller_esp32/Intro_Screens/onboarding_screens_2.dart';
import 'package:motor_controller_esp32/Intro_Screens/onboarding_screens_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreens extends StatefulWidget {
  const IntroScreens({Key? key}) : super(key: key);

  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  PageController _pageController = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              onLastPage = index == 2 ? true : false;
            });
          },
          controller: _pageController,
          children: const [
            OnBoardingScreen1(),
            OnBoardingScreen2(),
            OnBoardingScreen3()
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'skip',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 20, color: Colors.grey[400]),
                    ),
                    onPressed: () => _pageController.jumpToPage(2)),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect:
                      const ExpandingDotsEffect(activeDotColor: Colors.grey),
                ),
                onLastPage
                    ? CupertinoButton(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'done',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 20, color: Colors.grey[400]),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return MainPage();
                          }), (route) => false);
                        })
                    : CupertinoButton(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'next',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 20, color: Colors.grey[400]),
                        ),
                        onPressed: () => _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeIn)),
              ],
            ))
      ],
    ));
  }
}
