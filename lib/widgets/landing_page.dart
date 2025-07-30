import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/theme_provider.dart';
import 'package:portfolio_webapp/widgets/career_journey_section.dart';
import 'package:portfolio_webapp/widgets/creative_pursuits_section.dart';
import 'package:portfolio_webapp/widgets/custom_app_bar.dart';
import 'package:portfolio_webapp/widgets/hero_section.dart';
import 'package:portfolio_webapp/widgets/experience_section.dart';
import 'package:portfolio_webapp/widgets/skills_section.dart';
import 'package:portfolio_webapp/widgets/projects_section.dart';
import 'package:portfolio_webapp/widgets/contact_section.dart';
import 'package:portfolio_webapp/widgets/theme_toggle_button.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(7, (index) => GlobalKey());
  final GlobalKey<ContactSectionState> _contactKey = GlobalKey<ContactSectionState>();
  final GlobalKey<CareerJourneySectionState> _careerKey = GlobalKey<CareerJourneySectionState>();
  final GlobalKey<CreativePursuitsSectionState> _creativePursuitsKey = GlobalKey<CreativePursuitsSectionState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if contact section is visible
    final contactContext = _sectionKeys[5].currentContext;
    if (contactContext != null) {
      final RenderBox renderBox = contactContext.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      // If the section is 30% visible from the top
      if (position.dy < screenHeight * 0.7 && position.dy > -renderBox.size.height * 0.3) {
        _contactKey.currentState?.checkVisibility();
      }
    }
  }

  void _scrollToSection(int index) {
    // Check if contact section is visible
    final contactContext = _sectionKeys[5].currentContext;
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );


      // Trigger contact animation manually when navigating to contact section
      if (index == 6) { // Contact section index
        Future.delayed(const Duration(milliseconds: 900), () {
          _contactKey.currentState?.triggerAnimation();
        });
      }

      if (index == 5) { // Creative pursuits section index
        Future.delayed(const Duration(milliseconds: 900), () {
          _creativePursuitsKey.currentState?.triggerNavAnimation();
        });
      }

      // Trigger career section animation when navigating to it
      if (index == 1) { // Career section index
        Future.delayed(const Duration(milliseconds: 900), () {
          _careerKey.currentState?.triggerNavAnimation();
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: ColorThemes.backgroundColor(isDarkMode),
          appBar: CustomAppBar(onMenuTap: _scrollToSection, isDarkMode: isDarkMode),
          body: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [ Container(key: _sectionKeys[0], child:  HeroSection(isDarkMode: isDarkMode)),
                    Container(key: _sectionKeys[1], child:  CareerJourneySection(key: _careerKey, isDarkMode: isDarkMode)),
                    Container(key: _sectionKeys[2], child:  ExperienceSection(isDarkMode: isDarkMode)),
                    Container(key: _sectionKeys[3], child:  SkillsSection(isDarkMode: isDarkMode)),
                    Container(key: _sectionKeys[4], child:  ProjectsSection(isDarkMode: isDarkMode)),
                    Container(key: _sectionKeys[5], child: CreativePursuitsSection(key: _creativePursuitsKey, isDarkMode: isDarkMode)),
                    Container(key: _sectionKeys[6], child:  ContactSection(key: _contactKey,isDarkMode: isDarkMode)),
                    _buildFooter(isDarkMode),
                    const SizedBox(height: 30,)
                  ],
                ),
              ),


              // Theme toggle button
              ThemeToggleButton(
                isDarkMode: themeProvider.isDarkMode,
                onToggle: themeProvider.toggleTheme,
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildFooter(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: ColorThemes.surfaceColor(isDarkMode),
      child:  Column(
        children: [
          Text(
            "Harshitha DS",
            style: TextStyle(
              color: ColorThemes.textPrimary(isDarkMode),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Software Engineer • Flutter Developer • QA Expert",
            style: TextStyle(color: ColorThemes.textSecondary(isDarkMode)),
          ),
          const SizedBox(height: 20),
          Text(
            "© 2025 Harshitha DS. All rights reserved.",
            style: TextStyle(color: ColorThemes.textSecondary(isDarkMode), fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}