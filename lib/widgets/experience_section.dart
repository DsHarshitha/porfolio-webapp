import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../utils/responsive.dart';

class ExperienceSection extends StatelessWidget {
  final bool isDarkMode;

  const ExperienceSection({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Experience",
            style: TextStyles.sectionTitle(isDarkMode),
          ),
          const SizedBox(height: 50),
          _buildExperienceCard(
            company: "MyGate",
            position: "Software Engineer I",
            duration: "November 2024 - Present",
            description: [
              "Core developer of the dedicated Smart Devices app with 5K+ downloads",
              "Led complete integration of MyGate Gateway and Remote Key",
              "Designed architecture for Video Doorbell device workflows",
              "Mentored junior developers and owned release processes",
            ],
            technologies: ["Flutter", "Dart", "BLOC", "Android Studio"],
          ),
          const SizedBox(height: 30),
          _buildExperienceCard(
            company: "MyGate",
            position: "Associate Software Engineer",
            duration: "Nov 2023 - Nov 2024",
            description: [
              "Key developer for MyGate Smart Device project",
              "Implemented state management using Flutter and Bloc",
              "Completed application rebranding for enhanced UX",
              "Improved developer onboarding speed by 40%",
            ],
            technologies: ["Flutter", "Dart", "BLOC", "Native Plugins"],
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard({
    required String company,
    required String position,
    required String duration,
    required List<String> description,
    required List<String> technologies,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorThemes.surfaceColor(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorThemes.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position,
                    style: TextStyles.sectionTitle(isDarkMode).copyWith(fontSize: 20),
                  ),
                  Text(
                    company,
                    style: TextStyles.bodyText(isDarkMode).copyWith(
                      color: ColorThemes.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                duration,
                style: TextStyles.bodyText(isDarkMode).copyWith(
                  color: ColorThemes.textSecondary(isDarkMode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...description.map((desc) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(color: ColorThemes.primaryColor)),
                Expanded(
                  child: Text(desc, style: TextStyles.bodyText(isDarkMode)),
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technologies.map((tech) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorThemes.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tech,
                style: TextStyles.bodyText(isDarkMode).copyWith(
                  color: ColorThemes.primaryColor,
                  fontSize: 12,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}