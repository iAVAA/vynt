import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vynt/screens/main_page.dart';

import '../constants.dart' as costants;

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
            costants.appName,
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      nextScreen: const Home(),
      backgroundColor: Colors.deepPurple,
      splashTransition: SplashTransition.scaleTransition,
      //pageTransitionType: PageTransitionType.fade, // TODO FIX IT
      curve: Curves.easeInOut,
    );
  }
}