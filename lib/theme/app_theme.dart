import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF4A6FFF);
  static const Color accentColor = Color(0xFF8A6FFF);
  static const Color backgroundColor = Color(0xFFF8F9FC);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF2D3142);
  static const Color secondaryTextColor = Color(0xFF9C9EB9);
  static const Color borderColor = Color(0xFFEAECF0);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A6FFF), Color(0xFF8A6FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xCCFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF1A1D2E);
  static const Color darkCardColor = Color(0xFF252A3D);
  static const Color darkTextColor = Color(0xFFF8F9FC);
  static const Color darkSecondaryTextColor = Color(0xFFABAFC4);
  static const Color darkBorderColor = Color(0xFF353A50);
  
  // Text styles
  static TextStyle get headingStyle => const TextStyle(
    fontFamily: 'SFPro',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static TextStyle get subheadingStyle => const TextStyle(
    fontFamily: 'SFPro',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: secondaryTextColor,
  );
  
  static TextStyle get bodyStyle => const TextStyle(
    fontFamily: 'SFPro',
    fontSize: 16,
    color: textColor,
  );
  
  static TextStyle get buttonTextStyle => const TextStyle(
    fontFamily: 'SFPro',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: TextTheme(
        displayLarge: headingStyle,
        bodyLarge: bodyStyle,
        labelLarge: buttonTextStyle,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textColor,
        onSurface: textColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
  
  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      textTheme: TextTheme(
        displayLarge: headingStyle.copyWith(color: darkTextColor),
        bodyLarge: bodyStyle.copyWith(color: darkTextColor),
        labelLarge: buttonTextStyle,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        background: darkBackgroundColor,
        surface: darkCardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: darkTextColor,
        onSurface: darkTextColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}