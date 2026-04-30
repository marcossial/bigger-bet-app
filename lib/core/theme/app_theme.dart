import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1A1A2E);

  // Brand
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonGreenDark = Color(0xFF2BCB10);

  // Button
  static const Color buttonBlue = Color(0xFF4A6CF7);
  static const Color buttonBlueDark = Color(0xFF3A5CE6);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSubtitle = Color(0xFFCCCCCC);

  // Page indicator
  static const Color dotActive = Color(0xFF4A6CF7);
  static const Color dotInactive = Color(0xFF555555);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
    );
  }
}
