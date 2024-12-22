import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:modular_ui/modular_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/screens/login_pages/save_user_data.dart';
import 'package:vynt/screens/login_pages/signup_page.dart';
import 'package:vynt/screens/main_page.dart';
import 'package:vynt/widgets/login_pages_widgets/onboarding_widgets.dart';
import 'package:vynt/controllers/theme_controller.dart';

import 'login_page.dart';

class MainLoginPage extends StatefulWidget {
  const MainLoginPage({super.key});

  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await saveUserData(userCredential.user);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
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
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Log in or register to explore your journey.",
              style: TextStyle(
                fontFamily: "AB",
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final _MainLoginPageState state =
        context.findAncestorStateOfType<_MainLoginPageState>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 60,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(25),
                  pressedOpacity: 0.8,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Log in'),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                height: 60,
                child: CupertinoButton.tinted(
                  borderRadius: BorderRadius.circular(25),
                  pressedOpacity: 0.8,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text('Register Now'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LineSeparatorWithText(
            text: 'OR',
            lineColor: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
            textColor: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareTile(
                onTap: () => state.signInWithGoogle(),
                imagePath: 'assets/icons/icon_google.svg',
                imageHeight: 50,
              ),
              const SizedBox(width: 25),
              SquareTile(
                onTap: () => {},
                imagePath: 'assets/icons/icon_apple.svg',
                imageHeight: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
