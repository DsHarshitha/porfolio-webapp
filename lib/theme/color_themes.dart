import 'package:flutter/material.dart';

class ColorThemes {

  static Color get primaryColor => const Color(0xFF2196F3);
  static Color get secondaryColor => const Color(0xFF1976D2);
  static Color get accentColor => const Color(0xFF00BCD4);

  // 👇 All methods now take isDarkMode as parameter
  static Color backgroundColor(bool isDarkMode) => isDarkMode
      ? const Color(0xFF0A0A0A)
      : const Color(0xFFF8F9FA);

  static Color surfaceColor(bool isDarkMode) => isDarkMode
      ? const Color(0xFF1E1E1E)
      : const Color(0xFFFFFFFF);

  static Color textPrimary(bool isDarkMode) => isDarkMode
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF1A1A1A);

  static Color textSecondary(bool isDarkMode) => isDarkMode
      ? const Color(0xFFB0B0B0)
      : const Color(0xFF6B7280);

  static Color cardColor(bool isDarkMode) => isDarkMode
      ? const Color(0xFF2D2D2D)
      : const Color(0xFFFFFFFF);

  static Color borderColor(bool isDarkMode) => isDarkMode
      ? const Color(0xFF404040)
      : const Color(0xFFE5E7EB);
}