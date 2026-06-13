import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _poppins = 'Poppins';
  static const String _playfair = 'PlayfairDisplay';

  static TextStyle displayLarge = TextStyle(
    fontFamily: _playfair,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.crimsonHeart,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: _playfair,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle h1 = TextStyle(
    fontFamily: _poppins,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: _poppins,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: _poppins,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: _poppins,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: _poppins,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: _poppins,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: _poppins,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: _poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textDark,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: _poppins,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: AppColors.textDark,
  );

  static TextStyle caption = TextStyle(
    fontFamily: _poppins,
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );

  static TextStyle phaseTag = TextStyle(
    fontFamily: _poppins,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    color: Colors.white,
  );

  static TextStyle dayNumber = TextStyle(
    fontFamily: _poppins,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle cycleCount = TextStyle(
    fontFamily: _poppins,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.crimsonHeart,
  );
}
