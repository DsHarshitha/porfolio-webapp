import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import '../utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onMenuTap;
  final bool isDarkMode;

  const CustomAppBar({super.key, required this.onMenuTap, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorThemes.backgroundColor(isDarkMode).withOpacity(0.95),
      elevation: 0,
      title:  Text(
        "Harshitha DS",
        style: TextStyle(
          color: ColorThemes.textPrimary(isDarkMode),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: Responsive.isMobile(context)
          ? [
        PopupMenuButton<int>(
          icon:  Icon(Icons.menu, color: ColorThemes.textPrimary(isDarkMode)),
          color: ColorThemes.surfaceColor(isDarkMode),
          onSelected: onMenuTap,
          itemBuilder: (context) => [
            _buildPopupMenuItem(0, "Home"),
            _buildPopupMenuItem(1, "Journey"),
            _buildPopupMenuItem(2, "Experience"),
            _buildPopupMenuItem(3, "Skills"),
            _buildPopupMenuItem(4, "Projects"),
            _buildPopupMenuItem(5, "Creatives"),
            _buildPopupMenuItem(6, "Contact"),
          ],
        ),
      ]
          : [
        _buildNavButton("Home", () => onMenuTap(0)),
        _buildNavButton("Journey", () => onMenuTap(1)),
        _buildNavButton("Experience", () => onMenuTap(2)),
        _buildNavButton("Skills", () => onMenuTap(3)),
        _buildNavButton("Projects", () => onMenuTap(4)),
        _buildNavButton("Creatives", () => onMenuTap(5)),
        _buildNavButton("Contact", () => onMenuTap(6)),
        const SizedBox(width: 20),
      ],
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem(int value, String text) {
    return PopupMenuItem<int>(
      value: value,
      child: Text(
        text,
        style:  TextStyle(color: ColorThemes.textPrimary(isDarkMode)),
      ),
    );
  }

  Widget _buildNavButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style:  TextStyle(
          color: ColorThemes.textPrimary(isDarkMode),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // This is the key part - we implement the preferredSize getter
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}