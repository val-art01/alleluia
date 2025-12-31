import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Définition des couleurs principales
  static const Color primaryBlue = Color(0xFF42A5F5); // Bleu principal
  static const Color secondaryYellow = Color.fromARGB(242, 253, 197, 28); // Jaune
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Blanc
  static const Color darkBackground = Color(0xFF121212);
  static const Color ongrey = Color.fromARGB(255, 100, 100, 100);

  // Thème clair
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
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppTheme.backgroundWhite,
      elevation: 0,
      indicatorColor: AppTheme.primaryBlue.withOpacity(0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? AppTheme.primaryBlue : AppTheme.ongrey,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 26,
          color: selected ? AppTheme.primaryBlue : AppTheme.ongrey,
        );
      }),
    ),

  );

  // Thème sombre
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
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppTheme.darkBackground,
      elevation: 0,
      indicatorColor: Colors.white.withOpacity(0.10),
    ),

  );
  
}
