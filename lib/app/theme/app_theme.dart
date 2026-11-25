import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final krubTextTheme = GoogleFonts.krubTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.krub(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      displayMedium: GoogleFonts.krub(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      titleLarge: GoogleFonts.krub(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      titleMedium: GoogleFonts.krub(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyLarge: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary, height: 1.5),
      bodyMedium: GoogleFonts.krub(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary, height: 1.4),
      labelLarge: GoogleFonts.krub(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.krub().fontFamily,
      textTheme: krubTextTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
    );
  }
}
