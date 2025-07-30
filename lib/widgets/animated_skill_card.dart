import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../widgets/visibility_detector.dart';

class AnimatedSkillCard extends StatefulWidget {
  final Map<String, dynamic> skill;
  final AnimationController progressController;
  final Animation<double> progressAnimation;
  final int index;
  final VoidCallback onSectionVisible;
  final bool isDarkMode;

  const AnimatedSkillCard({
    Key? key,
    required this.skill,
    required this.progressController,
    required this.progressAnimation,
    required this.index,
    required this.onSectionVisible,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<AnimatedSkillCard> createState() => _AnimatedSkillCardState();
}

class _AnimatedSkillCardState extends State<AnimatedSkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);

    if (isHovered) {
      _hoverController.forward();
      // ONLY reset and animate on hover, not from navigation
      widget.progressController.reset();
      widget.progressController.forward();
    } else {
      _hoverController.reverse();
      // Don't reset progress when hover ends - let it stay at current value
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('skill_${widget.skill["name"]}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) {
          widget.onSectionVisible();
        }
      },
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedBuilder(
          animation:
              Listenable.merge([_hoverController, widget.progressAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorThemes.surfaceColor(widget.isDarkMode),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered
                        ? widget.skill["color"]
                        : ColorThemes.primaryColor.withOpacity(0.3),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.skill["color"]
                          .withOpacity(0.2 * _glowAnimation.value),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.skill["color"].withOpacity(
                                _isHovered ? 0.3 : 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.skill["icon"],
                              color: widget.skill["color"],
                              size: _isHovered
                                  ? 28
                                  : 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyles.bodyText(widget.isDarkMode)
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                                color: _isHovered
                                    ? widget.skill["color"]
                                    : ColorThemes.textPrimary(
                                        widget.isDarkMode),
                                fontSize: _isHovered ? 18 : 16,
                              ),
                              child: Text(widget.skill["name"]),
                            ),
                          ),
                          // Always show animated percentage (not dependent on hover)
                          AnimatedBuilder(
                            animation: widget.progressAnimation,
                            builder: (context, child) {
                              final currentProgress =
                                  widget.progressAnimation.value *
                                      widget.skill["level"];
                              return AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  color: widget.skill["color"],
                                  fontWeight: FontWeight.bold,
                                  fontSize: _isHovered
                                      ? 18
                                      : 16, // 👈 Fixed: _isHovered instead of isHovered
                                ),
                                child: Text(
                                    "${(currentProgress * 100).toInt()}%"), // 👈 Fixed: added * operator
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorThemes.backgroundColor(widget.isDarkMode),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            // Main animated progress bar
                            AnimatedBuilder(
                              animation: widget.progressAnimation,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  widthFactor: widget.progressAnimation.value *
                                      widget.skill[
                                          "level"], // 👈 Fixed: added * operator
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          widget.skill["color"]
                                              .withOpacity(0.7),
                                          widget.skill["color"],
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: _isHovered
                                          ? [
                                              BoxShadow(
                                                color: widget.skill["color"]
                                                    .withOpacity(0.5),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Shimmer effect - ONLY on hover
                            if (_isHovered)
                              AnimatedBuilder(
                                animation: widget.progressAnimation,
                                builder: (context, child) {
                                  return FractionallySizedBox(
                                    widthFactor:
                                        widget.progressAnimation.value *
                                            widget.skill["level"],
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _isHovered
                            ? 16
                            : 0, // Fixed height instead of opacity
                        child: _isHovered
                            ? Text(
                                _getSkillLevel(widget.skill["level"]),
                                style: TextStyles.bodyText(widget.isDarkMode)
                                    .copyWith(
                                  fontSize: 11, // Reduced from 12
                                  color: widget.skill["color"],
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const SizedBox.shrink(),
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

  String _getSkillLevel(double level) {
    if (level >= 0.9) return "Expert";
    if (level >= 0.8) return "Advanced";
    if (level >= 0.7) return "Intermediate";
    if (level >= 0.5) return "Beginner";
    return "Learning";
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
}
