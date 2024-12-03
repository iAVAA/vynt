import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/screens/login_pages/signup_page.dart';

import '../../widgets/login_pages_widgets/onboarding_widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constants.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
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
                "Welcome Back",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: constants.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Log in to continue your journey.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 16,
                  color: constants.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const _LoginForm(),
              const SizedBox(height: 20),
              _SignupText(),
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

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _errorMessage = '';
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed in: ${credential.user}');
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            _errorMessage = 'The email address is not valid.';
            break;
          case 'user-disabled':
            _errorMessage = 'The user corresponding to the given email has been disabled.';
            break;
          case 'user-not-found':
            _errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            _errorMessage = 'Wrong password provided for that user.';
            break;
          case 'operation-not-allowed':
            _errorMessage = 'Email/password accounts are not enabled.';
            break;
          default:
            _errorMessage = 'An undefined Error happened: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
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
            controller: _passwordController,
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
          const SizedBox(height: 20),
          MUIOutlinedButton(
            text: 'Log in',
            onPressed: _submit,
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

class _SignupText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Don't have an account yet? ",
        style: TextStyle(color: constants.secondaryTextColor),
        children: [
          TextSpan(
            text: 'Register here!',
            style: TextStyle(
              color: constants.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
          ),
        ],
      ),
    );
  }
}