import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../utils/responsive.dart';

class HeroSection extends StatefulWidget {
  final bool isDarkMode; // 👈 Add parameter

  const HeroSection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.getHeight(context),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
      ),
      child: Row(
        children: [
          Expanded(
            flex: Responsive.isMobile(context) ? 1 : 2,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedGreetingWithName(),
                    const SizedBox(height: 20),
                    _buildAnimatedDescription(),
                    const SizedBox(height: 30),
                    _buildAnimatedButtons(),
                  ],
                ),
              ),
            ),
          ),
          if (!Responsive.isMobile(context))
            Expanded(
              child: _buildAnimatedAvatar(),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedGreetingWithName() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(
          "Hi, I'm ",
          style: TextStyle(
            color: ColorThemes.accentColor,
            fontSize: Responsive.isMobile(context) ? 18 : 24,
            height: 1.4,
          ),
        ),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              "Harshitha DS",
              textStyle: TextStyle(
                color: ColorThemes.primaryColor,
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 150),
            ),
            TypewriterAnimatedText(
              "a Software Engineer",
              textStyle: TextStyle(
                color: ColorThemes.primaryColor,
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 150),
            ),
            TypewriterAnimatedText(
              "a Flutter Developer",
              textStyle: TextStyle(
                color: ColorThemes.primaryColor,
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 150),
            ),
            TypewriterAnimatedText(
              "a Mobile Application Developer",
              textStyle: TextStyle(
                color: ColorThemes.primaryColor,
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 150),
            ),
            TypewriterAnimatedText(
              "a Web Developer",
              textStyle: TextStyle(
                color: ColorThemes.primaryColor,
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 150),
            ),
            TypewriterAnimatedText(
              "a QA Expert",
              textStyle: TextStyle(
                color: ColorThemes.primaryColor,
                fontSize: Responsive.isMobile(context) ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 150),
            ),
          ],
          repeatForever: true,
          pause: const Duration(milliseconds: 2000),
        ),
      ],
    );
  }

  Widget _buildAnimatedDescription() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Text(
                "Flutter enthusiast with 3+ years of experience building polished, high-performance mobile and web apps. Currently at MyGate as a Software Engineer I, working on smart device integrations and next-gen tech.",
              style: TextStyles.bodyText(widget.isDarkMode),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButtons() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Row(
            children: [
              _AnimatedButton(
                text: "Download CV",
                isPrimary: true,
                onPressed: () {},
                isDarkMode: widget.isDarkMode,
              ),
              const SizedBox(width: 20),
              _AnimatedButton(
                text: "Contact Me",
                isPrimary: false,
                onPressed: () {},
                isDarkMode: widget.isDarkMode,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAvatar() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...List.generate(3, (index) => _buildAnimatedCircle(index)),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ColorThemes.primaryColor.withOpacity(0.3),
                        ColorThemes.accentColor.withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorThemes.primaryColor.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/images/harshitha_img.png', width: 100,
                      height: 100,
                      fit: BoxFit.cover,),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCircle(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2000 + (index * 500)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 300 + (index * 50),
            height: 300 + (index * 50),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorThemes.primaryColor.withOpacity(0.2 - (index * 0.05)),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    super.dispose();
  }
}

class _AnimatedButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const _AnimatedButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: widget.isPrimary
                    ? ColorThemes.primaryColor.withOpacity(0.4)
                    : ColorThemes.primaryColor.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ]
                : [],
          ),
          child: widget.isPrimary
              ? ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorThemes.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),),
          )
              : OutlinedButton(
            onPressed: widget.onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: _isHovered
                    ? ColorThemes.accentColor
                    : ColorThemes.primaryColor,
              ),
              foregroundColor: _isHovered
                  ? ColorThemes.accentColor
                  : ColorThemes.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                color: _isHovered
                    ? ColorThemes.accentColor
                    : ColorThemes.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}