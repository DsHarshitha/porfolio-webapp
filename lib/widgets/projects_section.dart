import 'package:flutter/material.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/responsive.dart';
import '../models/project_model.dart';

class ProjectsSection extends StatefulWidget {
  final bool isDarkMode;
  const ProjectsSection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;

  final List<ProjectModel> projects = [
    ProjectModel(
      title: "MyGate Smart Devices App",
      description: "Core developer of the dedicated Smart Devices app with 5K+ downloads on Play Store. Complete IoT solution for smart door locks and devices.",
      technologies: ["Flutter", "Dart", "BLOC", "IoT", "BLE", "WiFi"],
      imageUrl: "assets/images/smart_devices.png",
      features: [
        "Smart Door Lock Integration",
        "Video Doorbell Support",
        "Remote Key Management",
        "Real-time Device Status",
        "Bluetooth & WiFi Connectivity"
      ],
    ),
    ProjectModel(
      title: "MyGate Gateway Integration",
      description: "Led complete integration from firmware experiments to end-to-end user flows. Product now available on Amazon.",
      technologies: ["Flutter", "Firmware", "API Integration", "State Management"],
      imageUrl: "assets/images/gateway.png",
      features: [
        "Firmware Integration",
        "End-to-end User Flows",
        "Device Pairing System",
        "Cloud Connectivity",
        "Production Ready"
      ],
    ),
    ProjectModel(
      title: "Expense Tracker",
      description: "A comprehensive Java Spring Boot application to track daily expenses with full CRUD operations.",
      technologies: ["Spring Boot", "Java", "MySQL", "REST API"],
      githubUrl: "https://github.com/DsHarshitha/Expense_tracker",
      imageUrl: "assets/images/expense_tracker.png",
      features: [
        "Add/Edit/Delete Expenses",
        "Category Management",
        "Monthly Reports",
        "RESTful APIs",
        "MySQL Database"
      ],
    ),
    ProjectModel(
      title: "QA Automation Framework",
      description: "Comprehensive testing framework for MyGate E-commerce platform with automated test suites.",
      technologies: ["Selenium", "Java", "TestNG", "Postman", "SQL"],
      imageUrl: "assets/images/qa_framework.png",
      features: [
        "Automated Test Suites",
        "API Testing Framework",
        "Bug Tracking Integration",
        "Performance Testing",
        "Cross-browser Testing"
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _staggerController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _staggerController,
            child: Text("Featured Projects", style: TextStyles.sectionTitle(widget.isDarkMode)),
          ),
          const SizedBox(height: 8),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _staggerController,
              curve: Curves.easeOutCubic,
            )),
            child: Text(
              "Here are some of my featured projects that showcase my skills and experience",
              style: TextStyles.bodyText(widget.isDarkMode),
            ),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = Responsive.isMobile(context);
              final itemWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 30) / 2;

              return Wrap(
                spacing: 30,
                runSpacing: 30,
                children: List.generate(projects.length, (index) {
                  return AnimatedBuilder(
                    animation: _staggerController,
                    builder: (context, child) {
                      final delay = index * 0.2;
                      final animationValue = Curves.easeOutCubic.transform(
                        (_staggerController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
                      );

                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - animationValue)),
                        child: Opacity(
                          opacity: animationValue,
                          child: SizedBox(
                            width: itemWidth,
                            child: _InteractiveProjectCard(
                              project: projects[index],
                              index: index,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                        ),
                      );
                    },
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
    _staggerController.dispose();
    super.dispose();
  }
}

class _InteractiveProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;
  final bool isDarkMode;

  const _InteractiveProjectCard({
    required this.project,
    required this.index,
    required this.isDarkMode,
  });

  @override
  State<_InteractiveProjectCard> createState() => _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<_InteractiveProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 5.0, end: 20.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: ColorThemes.surfaceColor(widget.isDarkMode),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered
                      ? ColorThemes.primaryColor
                      : ColorThemes.primaryColor.withOpacity(0.3),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorThemes.primaryColor.withOpacity(0.2),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
            child: IntrinsicHeight( // Add this
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProjectImage(),
                  Expanded(child: _buildProjectContent()),
                ],
              ),
            ),
          ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectImage() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorThemes.primaryColor.withOpacity(0.8),
            ColorThemes.accentColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background pattern
          ...List.generate(5, (index) => _buildFloatingIcon(index)),
          // Main icon
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_isHovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.code,
                size: _isHovered ? 60 : 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2000 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Positioned(
          left: (index * 40.0) + (20 * value),
          top: (index * 30.0) + (10 * value),
          child: Opacity(
            opacity: 0.3 * value,
            child: Icon(
              [Icons.flutter_dash, Icons.code, Icons.web, Icons.mobile_friendly, Icons.api][index],
              color: Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyles.sectionTitle(widget.isDarkMode).copyWith(
              fontSize: _isHovered ? 22 : 20,
              color: _isHovered ? ColorThemes.primaryColor : ColorThemes.textPrimary(widget.isDarkMode),
            ),
            child: Text(
              widget.project.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.project.description,
            style: TextStyles.bodyText(widget.isDarkMode).copyWith(fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Animated technology chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.project.technologies.take(4).map((tech) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? ColorThemes.primaryColor.withOpacity(0.3)
                      : ColorThemes.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: _isHovered
                      ? Border.all(color: ColorThemes.primaryColor.withOpacity(0.5))
                      : null,
                ),
                child: Text(
                  tech,
                  style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                    color: ColorThemes.primaryColor,
                    fontSize: 11,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),

         const SizedBox(height: 20,),

          // Animated buttons
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton.icon(
                    onPressed: () => _showProjectDetails(context, widget.project),
                    icon: Icon(Icons.visibility, size: _isHovered ? 18 : 16, color: Colors.white,),
                    label: const Text("View Details",  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isHovered
                          ? ColorThemes.accentColor
                          : ColorThemes.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.project.githubUrl != null) ...[
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _isHovered
                        ? ColorThemes.primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: IconButton(
                    onPressed: () => _launchUrl(widget.project.githubUrl!),
                    icon: Icon(
                      Icons.code,
                      color: _isHovered ? ColorThemes.accentColor : ColorThemes.primaryColor,
                      size: _isHovered ? 24 : 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _AnimatedProjectDialog(
        project: project,
        isDarkMode: widget.isDarkMode,
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
}

class _AnimatedProjectDialog extends StatefulWidget {
  final ProjectModel project;
  final bool isDarkMode;

  const _AnimatedProjectDialog({
    required this.project,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedProjectDialog> createState() => _AnimatedProjectDialogState();
}

class _AnimatedProjectDialogState extends State<_AnimatedProjectDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _dialogController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _dialogController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _dialogController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dialogController, curve: Curves.easeInOut),
    );

    _dialogController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dialogController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: ColorThemes.surfaceColor(widget.isDarkMode),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: Responsive.isMobile(context) ? double.infinity : 600,
                constraints: const BoxConstraints(maxHeight: 600),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.title,
                            style: TextStyles.sectionTitle(widget.isDarkMode).copyWith(fontSize: 24),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: ColorThemes.textPrimary(widget.isDarkMode)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.project.description, style: TextStyles.bodyText(widget.isDarkMode)),
                            const SizedBox(height: 20),

                            Text(
                              "Key Features:",
                              style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorThemes.textPrimary(widget.isDarkMode),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...widget.project.features.map((feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Icon(Icons.check_circle,
                                      color: ColorThemes.primaryColor, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(feature, style: TextStyles.bodyText(widget.isDarkMode))),
                                ],
                              ),
                            )),

                            const SizedBox(height: 20),
                            Text(
                              "Technologies Used:",
                              style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorThemes.textPrimary(widget.isDarkMode),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.project.technologies.map((tech) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ColorThemes.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tech,
                                  style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                                    color: ColorThemes.primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (widget.project.githubUrl != null) ...[
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUrl(widget.project.githubUrl!),
                          icon: const Icon(Icons.code),
                          label: const Text("View Source Code"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorThemes.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  void dispose() {
    _dialogController.dispose();
    super.dispose();
  }
}