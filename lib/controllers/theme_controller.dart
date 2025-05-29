import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    fontFamily: GoogleFonts.poppins().fontFamily,
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
      displayLarge: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.poppins(color: darkPrimaryColor),
      bodySmall: GoogleFonts.poppins(color: darkPrimaryColor.withOpacity(0.7)),
      labelLarge: GoogleFonts.poppins(color: darkPrimaryColor, fontWeight: FontWeight.bold),
      labelMedium: GoogleFonts.poppins(color: darkPrimaryColor),
      labelSmall: GoogleFonts.poppins(color: darkPrimaryColor.withOpacity(0.7)),
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
    fontFamily: GoogleFonts.poppins().fontFamily,
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
      displayLarge: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.poppins(color: lightPrimaryColor),
      bodySmall: GoogleFonts.poppins(color: lightPrimaryColor.withOpacity(0.7)),
      labelLarge: GoogleFonts.poppins(color: lightPrimaryColor, fontWeight: FontWeight.bold),
      labelMedium: GoogleFonts.poppins(color: lightPrimaryColor),
      labelSmall: GoogleFonts.poppins(color: lightPrimaryColor.withOpacity(0.7)),
    ),
    iconTheme: IconThemeData(
      color: lightPrimaryColor,
    ),
  );
}
