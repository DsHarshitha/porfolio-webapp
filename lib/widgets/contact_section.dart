import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_webapp/theme/color_themes.dart';
import 'package:portfolio_webapp/theme/text_themes.dart';
import '../utils/responsive.dart';

class ContactSection extends StatefulWidget {
  final bool isDarkMode;

  const ContactSection({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<ContactSection> createState() => ContactSectionState();
}

class ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _hasAnimated = false;
  late AnimationController _leftController;
  late AnimationController _rightController;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;
  late Animation<double> _leftFadeAnimation;
  late Animation<double> _rightFadeAnimation;

  @override
  void initState() {
    super.initState();

    _leftController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rightController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Left slide animation (Contact Info)
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _leftController,
      curve: Curves.easeOutBack,
    ));

    _leftFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _leftController,
      curve: Curves.easeInOut,
    ));

    // Right slide animation (Message Form)
    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _rightController,
      curve: Curves.easeOutBack,
    ));

    _rightFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rightController,
      curve: Curves.easeInOut,
    ));
  }

  void checkVisibility() {
    if (!_hasAnimated && mounted) {
      _hasAnimated = true;

      // Start left animation
      _leftController.forward();

      // Start right animation with slight delay
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _rightController.forward();
        }
      });
    }
  }

// Add this new method for navigation button clicks
  void triggerAnimation() {
    if (mounted) {
      // Reset controllers to beginning position
      _leftController.reset();
      _rightController.reset();

      // Mark as animated to prevent scroll interference
      _hasAnimated = true;

      // Start left animation
      _leftController.forward();

      // Start right animation with slight delay
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _rightController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: (VisibilityInfo info) {
        // Trigger animation when 30% of the widget is visible
        if (info.visibleFraction > 0.3 && !_hasAnimated) {
          checkVisibility();
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
            // Header
            Text(
              "Get In Touch",
              style: TextStyles.sectionTitle(widget.isDarkMode),
            ),
            const SizedBox(height: 20),
            Text(
              "I'm always open to discussing new opportunities and interesting projects. Let's connect!",
              style: TextStyles.bodyText(widget.isDarkMode),
            ),
            const SizedBox(height: 50),

            // Animated Content
            if (Responsive.isMobile(context))
              Column(
                children: [
                  _buildAnimatedContactInfo(),
                  const SizedBox(height: 40),
                  _buildAnimatedMessageForm(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildAnimatedContactInfo()),
                  const SizedBox(width: 60),
                  Expanded(flex: 2, child: _buildAnimatedMessageForm()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Rest of your methods remain exactly the same...
  Widget _buildAnimatedContactInfo() {
    return SlideTransition(
      position: _leftSlideAnimation,
      child: FadeTransition(
        opacity: _leftFadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Information",
              style: TextStyles.sectionTitle(widget.isDarkMode).copyWith(fontSize: 24),
            ),
            const SizedBox(height: 30),

            _buildContactItem(
              icon: Icons.email,
              title: "Email",
              subtitle: "harshithads21@gmail.com",
              onTap: () => _launchUrl("mailto:harshithads21@gmail.com"),
            ),
            const SizedBox(height: 20),

            _buildContactItem(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+91 9535522878",
              onTap: () => _launchUrl("tel:+919535522878"),
            ),
            const SizedBox(height: 20),

            _buildContactItem(
              icon: Icons.location_on,
              title: "Location",
              subtitle: "Bengaluru, India",
              onTap: null,
            ),
            const SizedBox(height: 30),

            Text(
              "Follow Me",
              style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                fontWeight: FontWeight.bold,
                color: ColorThemes.textPrimary(widget.isDarkMode),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildSocialButton(
                  icon: Icons.work,
                  onTap: () => _launchUrl("https://www.linkedin.com/in/harshitha-ds"),
                ),
                const SizedBox(width: 15),
                _buildSocialButton(
                  icon: Icons.code,
                  onTap: () => _launchUrl("https://github.com/DsHarshitha"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedMessageForm() {
    return SlideTransition(
      position: _rightSlideAnimation,
      child: FadeTransition(
        opacity: _rightFadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ColorThemes.surfaceColor(widget.isDarkMode),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColorThemes.primaryColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: ColorThemes.primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Send Message",
                  style: TextStyles.sectionTitle(widget.isDarkMode).copyWith(fontSize: 24),
                ),
                const SizedBox(height: 30),

                _buildTextField(
                  controller: _nameController,
                  label: "Your Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _emailController,
                  label: "Your Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _messageController,
                  label: "Your Message",
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorThemes.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Send Message",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorThemes.surfaceColor(widget.isDarkMode),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorThemes.primaryColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: ColorThemes.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorThemes.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: ColorThemes.primaryColor),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.bodyText(widget.isDarkMode).copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorThemes.textPrimary(widget.isDarkMode),
                  ),
                ),
                Text(subtitle, style: TextStyles.bodyText(widget.isDarkMode)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorThemes.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorThemes.primaryColor.withOpacity(0.3)),
        ),
        child: Icon(icon, color: ColorThemes.primaryColor),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: ColorThemes.textPrimary(widget.isDarkMode)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ColorThemes.textSecondary(widget.isDarkMode)),
        filled: true,
        fillColor: ColorThemes.backgroundColor(widget.isDarkMode),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorThemes.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorThemes.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorThemes.primaryColor),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      final String subject = "Portfolio Contact from ${_nameController.text}";
      final String body = """
Hello Harshitha,

${_messageController.text}

Best regards,
${_nameController.text}
${_emailController.text}
""";

      final String emailUrl = "mailto:harshithads21@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";

      _launchUrl(emailUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Opening email client..."),
          backgroundColor: ColorThemes.primaryColor,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
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
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }
}