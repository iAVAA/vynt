import 'package:flutter/material.dart';

const String appName = 'Vynt';
const double minNavBarHeight = 140;
Color? bgColor = Colors.grey.shade900;
Color? secondaryBgColor = Colors.grey.shade800;
Color primaryTextColor = Colors.white;
Color secondaryTextColor = Colors.grey;

Color warningColor = Color(0xFFFF9800);
Color errorColor = Color(0xFFF44336);
Color successColor = Color(0xFF13AD5D);

//* Dark Mode Colors
Color darkPrimaryColor = Color(0xFFF3E2FB);
Color darkSecondaryColor = Color(0xFF644172);
Color darkTertiaryColor = Color(0xFFDC40A4);
Color darkBackgroundColor = Color(0xFF320943);

//* Light Mode Colors
Color lightPrimaryColor = Color(0xFF320943);
Color lightSecondaryColor = Color(0xFFDCC8E5);
Color lightTertiaryColor = Color(0xFFDC40A4);
Color lightBackgroundColor = Color(0xFFF3E2FB);

/*
my_flutter_project/
│
├── android/                    # Native Android code
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/
│   │       └── main/
│   │           ├── AndroidManifest.xml
│   │           ├── java/
│   │           │   └── com/
│   │           │       └── example/
│   │           │           └── my_flutter_project/
│   │           │               └── MainActivity.java
│   │           └── res/
│   └── build.gradle
├── ios/                        # Native iOS code
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets/
│   │   ├── Info.plist
│   │   └── main.m
│   └── Podfile
├── lib/                        # Main Dart code
│   ├── screens/                # UI screens
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/                # Reusable widgets
│   │   ├── custom_button.dart
│   │   └── navigation_bar.dart
│   ├── utils/                  # Utility classes
│   │   ├── constants.dart
│   │   └── helpers.dart
│   ├── models/                 # Data models
│   │   ├── user.dart
│   │   └── post.dart
│   ├── providers/              # State management
│   │   ├── auth_provider.dart
│   │   └── feed_provider.dart
│   ├── services/               # Services (e.g., APIs, Firebase)
│   │   ├── firebase_service.dart
│   │   └── api_service.dart
│   ├── main.dart               # Entry point of the app
│   └── firebase_options.dart   # Firebase configuration
├── test/                       # Unit and widget tests
│   ├── widget_test.dart
│   └── mock_data.dart
├── assets/                     # Static assets
│   ├── images/
│   │   ├── logo.png
│   │   └── profile_placeholder.png
│   ├── fonts/
│   │   └── Roboto-Regular.ttf
│   └── json/
│       └── sample_data.json
├── pubspec.yaml                # Flutter project configuration
├── pubspec.lock                # Locked versions of dependencies
├── README.md                   # Project documentation
├── analysis_options.yaml       # Code analysis rules
├── .gitignore                  # Git ignored files
└── .metadata                   # Flutter project metadata
 */