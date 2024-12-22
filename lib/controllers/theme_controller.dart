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
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: darkPrimaryColor),
      bodyMedium: TextStyle(color: darkPrimaryColor),
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
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: lightPrimaryColor),
      bodyMedium: TextStyle(color: lightPrimaryColor),
    ),
  );
}
