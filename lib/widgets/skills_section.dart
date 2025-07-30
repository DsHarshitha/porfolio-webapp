import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../utils/responsive.dart';
import '../widgets/animated_skill_card.dart';

class SkillsSection extends StatefulWidget {
  final bool isDarkMode;

  const SkillsSection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _skillControllers;
  late List<Animation<double>> _skillAnimations;

  final List<Map<String, dynamic>> skills = [
    {"name": "Flutter", "level": 0.8, "icon": Icons.change_history, "color": Colors.blue},
    {"name": "Dart", "level": 0.8, "icon": Icons.code, "color": Colors.amberAccent},
    {"name": "Android", "level": 0.4, "icon": Icons.phone_android, "color": Colors.cyan},
    {"name": "Java", "level": 0.6, "icon": Icons.coffee, "color": Colors.orange},
    {"name": "Javascript", "level": 0.7, "icon": Icons.javascript, "color": Colors.pinkAccent},
    {"name": "Html/CSS", "level": 0.7, "icon": Icons.html, "color": Colors.pinkAccent},
    {"name": "React", "level": 0.5, "icon": Icons.science_rounded, "color": Colors.blueGrey},
    {"name": "API Testing", "level": 0.9, "icon": Icons.api, "color": Colors.green},
    {"name": "SQL", "level": 0.7, "icon": Icons.storage, "color": Colors.purple},
    {"name": "Selenium", "level": 0.9, "icon": Icons.web, "color": Colors.red},

  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _skillControllers = List.generate(
      skills.length,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      ),
    );

    _skillAnimations = _skillControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();
  }

  void triggerSkillAnimations() {
    _animationController.forward();
    for (int i = 0; i < _skillControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _skillControllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 60,
        vertical: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Skills & Expertise",
            style: TextStyles.sectionTitle(widget.isDarkMode),
          ),
          const SizedBox(height: 16),
          Text(
            "Technologies and tools I work with - Hover to see proficiency levels!",
            style: TextStyles.bodyText(widget.isDarkMode),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = Responsive.isMobile(context);
              final itemWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 20) / 2;

              return Wrap(
                spacing: 20,
                runSpacing: 30,
                children: List.generate(skills.length, (index) {
                  return SizedBox(
                    width: itemWidth,
                    child: AnimatedSkillCard(
                      skill: skills[index],
                      progressController: _skillControllers[index],
                      progressAnimation: _skillAnimations[index],
                      index: index,
                      onSectionVisible: triggerSkillAnimations,
                      isDarkMode: widget.isDarkMode,
                    ),
                  );
                }),
              );
            },
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _skillControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}