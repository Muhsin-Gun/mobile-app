import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4ADE80);
  static const Color secondary = Color(0xFF6366F1);
  static const Color accent = Color(0xFF22D3EE);
  
  static const Color darkBackground = Color(0xFF0B0F1A);
  static const Color darkSurface = Color(0xFF151A2E);
  static const Color darkCard = Color(0xFF1E2642);
  static const Color darkBorder = Color(0xFF2D3555);
  
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6);
  
  static const Color bullish = Color(0xFF4ADE80);
  static const Color bearish = Color(0xFFEF4444);
  static const Color neutral = Color(0xFF94A3B8);
  
  static const Color chartLine = Color(0xFF6366F1);
  static const Color chartFill = Color(0x336366F1);
  static const Color orderBlock = Color(0xFF22D3EE);
  static const Color fairValueGap = Color(0xFFFBBF24);
  static const Color liquidity = Color(0xFFEC4899);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4ADE80), Color(0xFF22D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color lightScaffoldColor = lightBackground;
  static const Color darkScaffoldColor = darkBackground;
  static const Color lightPrimary = primary;
  static const Color darkPrimary = primary;
  static const Color lightCardColor = lightCard;
}
