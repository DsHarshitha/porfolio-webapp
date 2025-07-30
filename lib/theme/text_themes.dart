import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';

class TextStyles {

  static TextStyle heroTitle(bool isDarkMode) => TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: ColorThemes.textPrimary(isDarkMode),
    height: 1.2,
  );

  static TextStyle heroSubtitle(bool isDarkMode) => TextStyle(
    fontSize: 24,
    color: ColorThemes.textSecondary(isDarkMode),
    height: 1.4,
  );

  static TextStyle sectionTitle(bool isDarkMode) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: ColorThemes.textPrimary(isDarkMode),
  );

  static TextStyle bodyText(bool isDarkMode) => TextStyle(
    fontSize: 16,
    color: ColorThemes.textSecondary(isDarkMode),
    height: 1.6,
  );
}