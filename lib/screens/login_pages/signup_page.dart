import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/screens/login_pages/login_page.dart';
import 'package:vynt/screens/login_pages/save_user_data.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/login_pages_widgets/onboarding_widgets.dart';
import '../main_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: textTheme.bodyLarge?.color ?? Colors.black,
          ),
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  color: textTheme.bodyLarge?.color ?? Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Sign up to start your journey.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 16,
                  color: textTheme.bodySmall?.color ?? Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const _SignupForm(),
              const SizedBox(height: 20),
              _LoginText(),
              const SizedBox(height: 20),
              LineSeparatorWithText(
                text: 'OR',
                lineColor: textTheme.bodyLarge?.color ?? Colors.grey,
                textColor: textTheme.bodyLarge?.color ?? Colors.grey,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () async {
                      if (await GoogleProvider().signIn()) {
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const Home(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
                    },
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

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _loadingButtonController =
    RoundedLoadingButtonController();
  String _errorMessage = '';
  bool _isPasswordVisible = false;

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

    if (_emailController.text.isEmpty) {
      setState(() {
        _loadingButtonController.reset();
        _errorMessage = 'Email cannot be empty.';
      });
      return;
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _loadingButtonController.reset();
        _errorMessage = 'Password cannot be empty.';
      });
      return;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await saveUserData(credential.user);

      _loadingButtonController.success();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const Home()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(e.code, e.message);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
        });
      }
    }
  }

  String _getErrorMessage(String code, String? message) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'The user corresponding to the given email has been disabled.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'An undefined Error happened: $message';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
              hintStyle: TextStyle(color: textTheme.bodyMedium?.color),
              filled: true,
              fillColor: colorScheme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: textTheme.bodyMedium?.color),
              filled: true,
              fillColor: colorScheme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: textTheme.bodyMedium?.color,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ),
            obscureText: !_isPasswordVisible,
            style: TextStyle(color: textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 60,
            child: RoundedLoadingButton(
              color: colorScheme.primary,
              controller: _loadingButtonController,
              onPressed: _submit,
              completionCurve: Curves.easeInOut,
              elevation: 0.2,
              child: Text(
                'Sign up',
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
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
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        children: [
          TextSpan(
            text: 'Log in here!',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                );
              },
          ),
        ],
      ),
    );
  }
}
