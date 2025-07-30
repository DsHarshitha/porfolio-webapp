import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Dark Theme
  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    fontFamily: 'Poppins',
  );

  // Light Theme with color scheme override
  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    fontFamily: 'Poppins',
    
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF00BCD4),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF8F9FA),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onBackground: Color(0xFF1A1A1A),
    ),
  );
}