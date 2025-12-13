import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData({required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      primaryColor: AppColors.primary,
      colorScheme: isDarkTheme
          ? const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.darkSurface,
              error: AppColors.error,
            )
          : const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.lightSurface,
              error: AppColors.error,
            ),
      cardColor: isDarkTheme ? AppColors.darkCard : AppColors.lightCard,
      textTheme: GoogleFonts.interTextTheme(
        isDarkTheme ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
        titleTextStyle: GoogleFonts.inter(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkTheme ? AppColors.darkCard : AppColors.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDarkTheme ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDarkTheme ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
