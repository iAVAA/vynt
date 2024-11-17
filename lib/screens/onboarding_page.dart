import 'package:flutter/material.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/square_tile.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
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
              const Text(
                "Millions of songs.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 28,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "To share with your friends.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 28,
                  color: Colors.white,
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MUIPrimaryButton(
            text: 'Register Now!',
            onPressed: () {},
            textColor: Colors.black,
            bgColor: Colors.white,
            hapticsEnabled: true,
            borderRadius: 25,
            widthFactorUnpressed: 0.05,
            widthFactorPressed: 0.045,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareTile(
                onTap: () {},
                imagePath: 'assets/icons/icon_google.svg',
                height: 50,
              ),
              const SizedBox(width: 20),
              SquareTile(
                onTap: () {},
                imagePath: 'assets/icons/icon_apple.svg',
                height: 50,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Log in",
            style: TextStyle(
              fontFamily: "AB",
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
