import 'package:flutter/material.dart';

import 'package:modular_ui/modular_ui.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/widgets/login_pages_widgets/onboarding_widgets.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constants.bgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/logo/vynt_logo.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to Vynt",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: constants.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Log in or register to explore your journey.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 16,
                  color: constants.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const _ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareTile(
                onTap: () {},
                imagePath: 'assets/icons/icon_google.svg',
                height: 50,
              ),
              const SizedBox(width: 25),
              SquareTile(
                onTap: () {},
                imagePath: 'assets/icons/icon_apple.svg',
                height: 50,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const LineSeparatorWithText(
            text: 'OR',
            lineColor: Colors.white54,
            textColor: Colors.white70,
          ),
          const SizedBox(height: 20),
          MUIOutlinedButton(
            text: 'Register Now!',
            onPressed: () {},
            textColor: constants.primaryTextColor,
            hapticsEnabled: true,
            borderColor: Colors.white,
            borderWidth: 1,
            borderRadius: 25,
            widthFactorUnpressed: 0.05,
            widthFactorPressed: 0.045,
          ),
          const SizedBox(height: 20),
          MUIOutlinedButton(
            text: 'Log in',
            onPressed: () {},
            textColor: constants.primaryTextColor,
            hapticsEnabled: true,
            borderColor: Colors.white,
            borderWidth: 1,
            borderRadius: 25,
            widthFactorUnpressed: 0.15,
            widthFactorPressed: 0.145
          ),
        ],
      ),
    );
  }
}
