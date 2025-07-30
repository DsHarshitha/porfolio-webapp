import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import 'package:portfolio_webapp/widgets/animated_timeline_step.dart';
import '../utils/responsive.dart';

class CareerJourneySection extends StatefulWidget {
  final bool isDarkMode;


  const CareerJourneySection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<CareerJourneySection> createState() => CareerJourneySectionState();
}

class CareerJourneySectionState extends State<CareerJourneySection>
    with TickerProviderStateMixin {

  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  bool _hasScrollAnimated = false; // Track scroll-based animation
  List<bool> _stepVisibility = [];
  int _animationTriggerCount = 0; // Track how many times we've animated

  final List<Map<String, dynamic>> journeySteps = [
    {
      "year": "2017-2021",
      "title": "Electronics & Communication Engineering",
      "subtitle": "Sai Vidya Institute of Technology",
      "description": "Started my journey in Electronics & Communication Engineering with a CGPA of 8.31. During my studies, I developed a strong foundation in problem-solving and analytical thinking.",
      "icon": Icons.school,
      "color": const Color(0xFF2196F3),
      "achievements": ["CGPA: 8.31", "Strong Foundation", "Problem Solving"]
    },
    {
      "year": "2021-2022",
      "title": "QA Engineer Trainee",
      "subtitle": "Learning the Fundamentals",
      "description": "After graduation, I discovered my passion for software quality and testing. I learned testing methodologies including functional, regression, and integration testing.",
      "icon": Icons.bug_report,
      "color": const Color(0xFFFF9800),
      "achievements": ["Testing Methodologies", "Attention to Detail", "Systematic Thinking"]
    },
    {
      "year": "Dec 2022 - Nov 2023",
      "title": "QA Engineer I at MyGate",
      "subtitle": "Mastering Quality Assurance",
      "description": "Took sole ownership as QA for MyGate E-commerce platform. Conducted test cases, verified bug reports, and helped recreate critical customer-impacting problems.",
      "icon": Icons.verified,
      "color": const Color(0xFF4CAF50),
      "achievements": ["Sole QA Ownership", "Agile Leadership", "Team Mentoring"]
    },
    {
      "year": "Nov 2023 - Nov 2024",
      "title": "Associate Software Engineer",
      "subtitle": "Transitioning to Development",
      "description": "Made the strategic switch to development! Became a key developer for MyGate Smart Device project, building UI platforms for IoT solutions.",
      "icon": Icons.code,
      "color": const Color(0xFF9C27B0),
      "achievements": ["Flutter & Bloc", "IoT Solutions", "40% Efficiency Boost"]
    },
    {
      "year": "Nov 2024 - Present",
      "title": "Software Engineer I",
      "subtitle": "Leading Innovation",
      "description": "Now leading as core developer of the Smart Devices app with 5K+ downloads. Successfully led complete integration of MyGate Gateway and Remote Key.",
      "icon": Icons.rocket_launch,
      "color": const Color(0xFFF44336),
      "achievements": ["5K+ Downloads", "Production Leadership", "Team Mentoring"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _stepVisibility = List.filled(journeySteps.length, false);

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    ));
  }

  // Method for scroll-based animation (happens once per scroll)
  void _triggerScrollAnimation() {
    if (!_hasScrollAnimated) {
      _hasScrollAnimated = true;
      _startHeaderAnimation();
    }
  }

  void triggerNavAnimation() {
    _animationTriggerCount++;

    // Reset header animation
    _headerController.reset();

    // Reset all step visibility
    setState(() {
      _stepVisibility = List.filled(journeySteps.length, false);
      _hasScrollAnimated = false; // Add this line - reset scroll animation capability
    });

    // Start header animation
    _startHeaderAnimation();

    // Trigger all steps with timing for nav
    for (int i = 0; i < journeySteps.length; i++) {
      Future.delayed(Duration(milliseconds: 600 + (i * 400)), () {
        if (mounted) {
          setState(() {
            _stepVisibility[i] = true;
          });
        }
      });
    }
  }

  void _startHeaderAnimation() {
    _headerController.forward();
  }

  void _triggerAllStepsWithDelay() {
    for (int i = 0; i < journeySteps.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 200)), () {
        if (mounted) {
          setState(() {
            _stepVisibility[i] = true;
          });
        }
      });
    }
  }

  void _triggerStepAnimation(int index) {
    if (!_stepVisibility[index]) {
      setState(() {
        _stepVisibility[index] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('career-journey-section-$_animationTriggerCount'), // Unique key for each animation
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.2) {
          _triggerScrollAnimation(); // Only for scroll-based animation
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 20 : 80,
          vertical: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedHeader(),
            const SizedBox(height: 60),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorThemes.primaryColor,
                        ColorThemes.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ColorThemes.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.timeline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Career Journey",
                        style: TextStyles.sectionTitle(widget.isDarkMode),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "From Electronics Engineering to Software Development - Here's how I evolved",
                        style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: journeySteps.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> step = entry.value;
        bool isEven = index % 2 == 0;

        return VisibilityDetector(
          key: Key('timeline-step-$index-$_animationTriggerCount'),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.4) {
              // Card is visible - trigger animation
              _triggerStepAnimation(index);
            } else if (info.visibleFraction < 0.1) {
              // Card is out of view - reset it for next time
              setState(() {
                _stepVisibility[index] = false;
              });
            }
          },
          child: AnimatedTimelineStep(
            key: Key('step-$index-$_animationTriggerCount'),
            step: step,
            index: index,
            isEven: isEven,
            isLast: index == journeySteps.length - 1,
            isDarkMode: widget.isDarkMode,
            isVisible: _stepVisibility[index],
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }
}