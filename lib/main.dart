import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/theme_provider.dart';
import 'package:portfolio_webapp/widgets/landing_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Harshitha DS - Portfolio',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme.copyWith(
              // 👇 Force text color override at app level
              textTheme: themeProvider.currentTheme.textTheme.apply(
                bodyColor: themeProvider.isDarkMode
                    ? Colors.white
                    : const Color(0xFF1A1A1A), // BLACK in light mode
                displayColor: themeProvider.isDarkMode
                    ? Colors.white
                    : const Color(0xFF1A1A1A), // BLACK in light mode
              ),
            ),
            home: const LandingPage(),
          );
        },
      ),
    );
  }
}