import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';

class ThemeToggleButton extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggleButton({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 30,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: widget.onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorThemes.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: ColorThemes.primaryColor.withOpacity(_isHovered ? 0.4 : 0.2),
                        blurRadius: _isHovered ? 15 : 8,
                        spreadRadius: _isHovered ? 2 : 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _iconRotation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _iconRotation.value * 3.14159, // 180 degrees
                            child: Icon(
                              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                              size: 20,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          widget.isDarkMode ? "Turn on lights" : "Turn off lights",
                          key: ValueKey(widget.isDarkMode),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}