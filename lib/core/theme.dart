import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color saffron = Color(0xFFFF7043);
  static const Color teal = Color(0xFF26A69A);
  static const Color deepTeal = Color(0xFF00695C);
  static const Color gold = Color(0xFFFBC02D);
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color cardBg = Color(0xFF1E293B); // Slate 800
  static const Color textMain = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.saffron,
        secondary: AppColors.teal,
        surface: AppColors.cardBg,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
            bodyMedium: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
