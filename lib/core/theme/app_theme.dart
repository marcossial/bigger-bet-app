import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color cardBlueDark = Color(0xFF0F1524);
  static const Color cardGreenDark = Color(0xFF101B14);
  static const Color darkCard = Color(0xFF0F0F0F);
  static const Color bottomNavBackground = Color(0xFF0D1015);

  // Brand
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonGreenDark = Color(0xFF2BCB10);
  static const Color neonPink = Color(0xFFFF2D55);
  static const Color neonBlue = Color(0xFF4A6CF7);

  // Borders
  static const Color cardBorder = Color(0xFF2A2D35);

  // Button
  static const Color buttonBlue = Color(0xFF4A6CF7);
  static const Color buttonBlueDark = Color(0xFF3A5CE6);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSubtitle = Color(0xFFCCCCCC);
  static const Color textGrey = Color(0xFF8A8F98);

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
