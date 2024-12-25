import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/screens/login_pages/save_user_data.dart';
import 'package:vynt/screens/login_pages/signup_page.dart';

import '../../widgets/login_pages_widgets/onboarding_widgets.dart';
import '../main_page.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: Theme.of(context).canvasColor,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
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
                  color: Theme.of(context).textTheme.bodyLarge?.color ??
                      Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Log in to continue your journey.",
                style: TextStyle(
                  fontFamily: "AB",
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color ??
                      Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const _LoginForm(),
              const SizedBox(height: 20),
              _SignupText(),
              const SizedBox(height: 20),
              LineSeparatorWithText(
                text: 'OR',
                lineColor:
                    Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
                textColor:
                    Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
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

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
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
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await saveUserData(credential.user);

      _loadingButtonController.success();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          switch (e.code) {
            case 'invalid-email':
              _errorMessage = 'The email address is not valid.';
              break;
            case 'user-disabled':
              _errorMessage =
                  'The user corresponding to the given email has been disabled.';
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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
        });
      }
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
              hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 60,
            child: RoundedLoadingButton(
              color: Theme.of(context).colorScheme.primary,
              controller: _loadingButtonController,
              onPressed: _submit,
              child: Text('Log in',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
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
