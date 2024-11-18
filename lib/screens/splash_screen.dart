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
          const Icon(
            Icons.music_note,
            size: 25,
            color: Colors.white,
          ),
          Text(
            constants.appName,
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      nextScreen: const Home(),
      backgroundColor: Colors.grey.shade900,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.fade,
      curve: Curves.easeInOut,
    );
  }
}
