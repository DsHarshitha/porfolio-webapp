import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../utils/responsive.dart';

class CreativePursuitsSection extends StatefulWidget {
  final bool isDarkMode;

  const CreativePursuitsSection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<CreativePursuitsSection> createState() => CreativePursuitsSectionState();
}

class CreativePursuitsSectionState extends State<CreativePursuitsSection> {

  final List<Map<String, dynamic>> creativePursuits = [
    {
      "icon": Icons.palette_outlined,
      "color": const Color(0xFF4CAF50),
      "title": "Canvas Painting",
      "description": "Friends keep asking for my abstract dog paintings and animated character portraits - and yeah, I sell them",
    },
    {
      "icon": Icons.draw_outlined,
      "color": const Color(0xFF2196F3),
      "title": "Surreal Concept Sketches",
      "description": "Drawing weird concepts like girls drowning in bottles - it's therapeutic",
    },
  ];

  void triggerNavAnimation() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: 60,
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          _buildCreativeCards(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Beyond Code",
          style: TextStyles.sectionTitle(widget.isDarkMode),
        ),
        const SizedBox(height: 8),
        Text(
          "The creative stuff that keeps me balanced",
          style: TextStyles.bodyText(widget.isDarkMode).copyWith(
            color: ColorThemes.textSecondary(widget.isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeCards() {
    if (Responsive.isMobile(context)) {
      return Column(
        children: creativePursuits.map((pursuit) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildCreativeCard(pursuit),
            )
        ).toList(),
      );
    }

    return Row(
      children: creativePursuits.map((pursuit) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildCreativeCard(pursuit),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCreativeCard(Map<String, dynamic> pursuit) {
    return StatefulBuilder(
      builder: (context, setHoverState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setHoverState(() => isHovered = true),
          onExit: (_) => setHoverState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorThemes.surfaceColor(widget.isDarkMode),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovered
                    ? pursuit["color"].withOpacity(0.5)
                    : ColorThemes.primaryColor.withOpacity(0.1),
                width: isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: pursuit["color"].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    pursuit["icon"],
                    color: pursuit["color"],
                    size: 20,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pursuit["title"],
                  style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: pursuit["color"],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pursuit["description"],
                  style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}