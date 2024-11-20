import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/screens/login_pages/login_page.dart';

import '../../widgets/login_pages_widgets/onboarding_widgets.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constants.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white
          ),
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
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
              Text(
                "Create Account",
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
                "Sign up to start your journey.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 16,
                  color: constants.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const _SignupForm(),
              const SizedBox(height: 20),
              _LoginText(),
              const SizedBox(height: 20),
              const _ActionButtons(),
              const SizedBox(height: 20),
              const LineSeparatorWithText(
                text: 'OR',
                lineColor: Colors.white54,
                textColor: Colors.white70,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () {},
                    imagePath: 'assets/icons/icon_google.svg',
                    imageHeight: 50,
                  ),
                  const SizedBox(width: 25),
                  SquareTile(
                    onTap: () {},
                    imagePath: 'assets/icons/icon_apple.svg',
                    imageHeight: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(color: constants.secondaryTextColor),
              filled: true,
              fillColor: constants.secondaryBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: constants.primaryTextColor),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: constants.secondaryTextColor),
              filled: true,
              fillColor: constants.secondaryBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            obscureText: true,
            style: TextStyle(color: constants.primaryTextColor),
          ),
        ],
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
          MUIOutlinedButton(
            text: 'Sign up',
            onPressed: () {},
            textColor: Colors.black,
            hapticsEnabled: true,
            borderColor: Colors.white,
            bgColor: Colors.white,
            borderWidth: 1,
            borderRadius: 25,
            widthFactorUnpressed: 0.1,
            widthFactorPressed: 0.095,
          ),
        ],
      ),
    );
  }
}

class _LoginText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: TextStyle(color: constants.secondaryTextColor),
        children: [
          TextSpan(
            text: 'Log in here!',
            style: TextStyle(
              color: constants.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
          ),
        ],
      ),
    );
  }
}