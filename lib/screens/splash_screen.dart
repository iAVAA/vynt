import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';

import 'package:vynt/screens/main_page.dart';
import 'package:vynt/constants/constants.dart' as constants;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splashScreen => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/logo/vynt_logo.png',
            height: 200,
            width: 200,
          ),
        ],
      ),
      nextScreen: const Home(),
      splashIconSize: 200,
      backgroundColor: Colors.grey.shade900,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.fade,
      curve: Curves.easeInOut,
    );
  }
}
