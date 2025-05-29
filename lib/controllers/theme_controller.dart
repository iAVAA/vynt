import 'package:flutter/material.dart';
import 'package:vynt/constants/constants.dart';

class ThemeController with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setThemeMode(Brightness brightness) {
    _isDarkMode = brightness == Brightness.dark;
    notifyListeners();
  }

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      tertiary: darkTertiaryColor,
      surface: darkBackgroundColor,
      onPrimary: darkBackgroundColor,
      onSecondary: darkPrimaryColor,
      onSurface: darkPrimaryColor,
      onBackground: darkPrimaryColor,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: darkPrimaryColor),
      bodyMedium: TextStyle(color: darkPrimaryColor),
      bodySmall: TextStyle(color: darkPrimaryColor.withOpacity(0.7)),
      labelLarge: TextStyle(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(color: darkPrimaryColor),
      labelSmall: TextStyle(color: darkPrimaryColor.withOpacity(0.7)),
    ),
    iconTheme: IconThemeData(
      color: darkPrimaryColor,
    ),
  );

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
      tertiary: lightTertiaryColor,
      surface: lightBackgroundColor,
      onPrimary: lightBackgroundColor,
      onSecondary: lightPrimaryColor,
      onSurface: lightPrimaryColor,
      onBackground: lightPrimaryColor,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: lightPrimaryColor),
      bodyMedium: TextStyle(color: lightPrimaryColor),
      bodySmall: TextStyle(color: lightPrimaryColor.withOpacity(0.7)),
      labelLarge: TextStyle(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(color: lightPrimaryColor),
      labelSmall: TextStyle(color: lightPrimaryColor.withOpacity(0.7)),
    ),
    iconTheme: IconThemeData(
      color: lightPrimaryColor,
    ),
  );
}
