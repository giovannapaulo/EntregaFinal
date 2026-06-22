import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkPurple = Color(0xFF423D9E);
  static const Color sensivPink = Color(0xFFF653A1);
  static const Color textPurpleDark = Color(0xFF4A2A73);
  static const Color pastelPurple = Color(0xFFE6E1FF);
  static const Color pastelPink = Color(0xFFFFB3D1);

  static InputDecorationTheme _buildInputTheme(
      Color fillColor, Color textColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIconColor: textColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPurple, width: 2),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: pastelPurple,
      colorScheme: const ColorScheme.light(secondary: pastelPink),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: _buildInputTheme(Colors.white, textPurpleDark),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPurple,
      colorScheme: const ColorScheme.dark(secondary: sensivPink),
      scaffoldBackgroundColor: const Color(0xFF121212),
      inputDecorationTheme:
          _buildInputTheme(const Color(0xFF2C2C2C), Colors.white),
    );
  }
}
