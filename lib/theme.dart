import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Darker navy background to match image
  static const Color background = Color(0xFF0F1121);
  // Slightly lighter surface for cards
  static const Color surface = Color(0xFF1E2139);
  // Vibrant orange/gold for brand identity
  static const Color primary = Color(0xFFFFA500); 
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color accent = Color(0xFF2D3250);
}

class AppTheme {
  static ThemeData get darkTheme {
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      // Set Poppins as the default font for all text
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
        headlineMedium: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textSecondary),
      ),
    );
  }
}
