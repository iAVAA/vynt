import 'package:flutter/material.dart';

class DarkModeController with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get darkTheme => ThemeData(
    // TODO: DARK MODE COLORS
  );

  ThemeData get lightTheme => ThemeData(
    // TODO: LIGHT MODE COLORS
  );
}