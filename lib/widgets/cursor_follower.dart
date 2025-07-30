import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';

class CursorFollower extends StatefulWidget {
  const CursorFollower({Key? key}) : super(key: key);

  @override
  State<CursorFollower> createState() => _CursorFollowerState();
}

class _CursorFollowerState extends State<CursorFollower>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Offset _cursorPosition = const Offset(0, 0);
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            _cursorPosition = event.localPosition;
            _isVisible = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isVisible = false;
          });
        },
        child: Stack(
          children: [
            if (_isVisible)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _cursorPosition.dx - 25,
                top: _cursorPosition.dy - 25,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorThemes.primaryColor.withOpacity(0.6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorThemes.primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorThemes.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}