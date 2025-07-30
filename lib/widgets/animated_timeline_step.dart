import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../utils/responsive.dart';

class AnimatedTimelineStep extends StatefulWidget {
  final Map<String, dynamic> step;
  final int index;
  final bool isEven;
  final bool isLast;
  final bool isDarkMode;
  final bool isVisible;

  const AnimatedTimelineStep({
    Key? key,
    required this.step,
    required this.index,
    this.isEven = false,
    required this.isLast,
    required this.isDarkMode,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<AnimatedTimelineStep> createState() => _AnimatedTimelineStepState();
}

class _AnimatedTimelineStepState extends State<AnimatedTimelineStep>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _iconController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconPulseAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isEven ? -0.3 : 0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _iconPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ));

    _iconController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimatedTimelineStep oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset and restart animation when widget key changes (nav trigger)
    if (widget.key != oldWidget.key) {
      _hasAnimated = false;
      _controller.reset();
    }

    // Start animation when visible
    if (widget.isVisible && (!_hasAnimated || widget.key != oldWidget.key)) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _iconController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Responsive.isMobile(context)
                ? _buildMobileLayout()
                : _buildDesktopLayout(),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildAnimatedIcon(isMobile: true),
              if (!widget.isLast) _buildConnectingLine(isMobile: true),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(child: _buildContentCard(isMobile: true)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          if (widget.isEven) ...[
            Expanded(child: _buildContentCard(isMobile: false)),
            const SizedBox(width: 40),
          ] else ...[
            const Expanded(child: SizedBox()),
            const SizedBox(width: 40),
          ],
          Column(
            children: [
              _buildAnimatedIcon(isMobile: false),
              if (!widget.isLast) _buildConnectingLine(isMobile: false),
            ],
          ),
          if (!widget.isEven) ...[
            const SizedBox(width: 40),
            Expanded(child: _buildContentCard(isMobile: false)),
          ] else ...[
            const SizedBox(width: 40),
            const Expanded(child: SizedBox()),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon({required bool isMobile}) {
    return AnimatedBuilder(
      animation: _iconPulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _iconPulseAnimation.value,
          child: Container(
            width: isMobile ? 60 : 70,
            height: isMobile ? 60 : 70,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  widget.step["color"],
                  widget.step["color"].withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.step["color"].withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              widget.step["icon"],
              color: Colors.white,
              size: isMobile ? 28 : 32,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectingLine({required bool isMobile}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      width: isMobile ? 3 : 4,
      height: widget.isVisible ? (isMobile ? 80 : 100) : 0,
      margin: EdgeInsets.only(top: isMobile ? 10 : 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorThemes.primaryColor,
            ColorThemes.primaryColor.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildContentCard({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorThemes.surfaceColor(widget.isDarkMode),
            ColorThemes.surfaceColor(widget.isDarkMode).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: widget.step["color"].withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.step["color"].withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYearBadge(isMobile: isMobile),
          SizedBox(height: isMobile ? 12 : 16),
          _buildTitle(isMobile: isMobile),
          SizedBox(height: isMobile ? 6 : 8),
          _buildSubtitle(isMobile: isMobile),
          SizedBox(height: isMobile ? 12 : 16),
          _buildDescription(isMobile: isMobile),
          SizedBox(height: isMobile ? 16 : 20),
          _buildAchievementChips(isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildYearBadge({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.step["color"],
            widget.step["color"].withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.step["color"].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        widget.step["year"],
        style: TextStyles.bodyText(widget.isDarkMode).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isMobile ? 12 : 13,
        ),
      ),
    );
  }

  Widget _buildTitle({required bool isMobile}) {
    return Text(
      widget.step["title"],
      style: TextStyles.sectionTitle(widget.isDarkMode).copyWith(
        fontSize: isMobile ? 18 : 22,
        color: widget.step["color"],
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubtitle({required bool isMobile}) {
    return Text(
      widget.step["subtitle"],
      style: TextStyles.bodyText(widget.isDarkMode).copyWith(
        fontWeight: FontWeight.w600,
        color: ColorThemes.textPrimary(widget.isDarkMode),
        fontSize: isMobile ? 14 : 16,
      ),
    );
  }

  Widget _buildDescription({required bool isMobile}) {
    return Text(
      widget.step["description"],
      style: TextStyles.bodyText(widget.isDarkMode).copyWith(
        fontSize: isMobile ? 14 : 15,
        height: 1.5,
      ),
    );
  }

  Widget _buildAchievementChips({required bool isMobile}) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children:
          (widget.step["achievements"] as List<String>).map((achievement) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: widget.step["color"].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.step["color"].withOpacity(0.3),
            ),
          ),
          child: Text(
            achievement,
            style: TextStyles.bodyText(widget.isDarkMode).copyWith(
              color: widget.step["color"],
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
  }
}
