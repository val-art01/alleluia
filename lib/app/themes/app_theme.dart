import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Définition des couleurs principales
  static const Color primaryBlue = Color(0xFF007BFF); // Bleu principal
  static const Color secondaryYellow = Color(0xFFFFC107); // Jaune
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Blanc
  static const Color darkBackground = Color(0xFF121212);

   // 🌞 Thème clair
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: Colors.white,
      secondary: secondaryYellow,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: backgroundWhite,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: backgroundWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryYellow,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );

  // 🌚 Thème sombre
   static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlue,
      onPrimary: Colors.white,
      secondary: secondaryYellow,
      onSecondary: Colors.black,
      background: darkBackground,
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
  );
}
