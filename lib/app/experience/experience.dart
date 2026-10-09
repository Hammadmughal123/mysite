import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/color/colors.dart';
import '../../../../core/res/responsive.dart';

// import '../../core/color/colors.dart';
// import '../../core/res/responsive.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late List<AnimationController> _skillControllers;
  late List<Animation<double>> _skillAnimations;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _underlineAnimation;

  // Hover states for each card
  List<bool> _hoverStates = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Title animation with proper bounds
    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
    ));

    // Subtitle animation
    _subtitleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    ));

    // Underline animation
    _underlineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
    ));

    // Initialize skill controllers
    final skillsData = _getSkillsData();
    _hoverStates = List.generate(skillsData.length, (index) => false);

    _skillControllers = List.generate(
      skillsData.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _skillAnimations = _skillControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();
  }

  void _startAnimations() async {
    // Start main animation immediately
    _mainAnimationController.forward();

    // Wait for main animation to start, then begin skill animations
    await Future.delayed(const Duration(milliseconds: 800));

    // Staggered skill animations
    for (int i = 0; i < _skillControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _skillControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    for (var controller in _skillControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 20 : 80,
          vertical: 38,
        ),
        child: Column(
          children: [
            _buildSectionHeader(theme),
            _buildSkillsGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Column(
      children: [
        // Animated title
        AnimatedBuilder(
          animation: _titleAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 40 * (1 - _titleAnimation.value)),
              child: Opacity(
                opacity: _titleAnimation.value.clamp(0.0, 1.0),
                child: Text(
                  'Technical Expertise',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 36 : 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1.2,
                    height: 1.2,
                  ),
                ),
              ),
            );
          },
        ),

        Space.y(2.w)!,

        // Animated underline
        AnimatedBuilder(
          animation: _underlineAnimation,
          builder: (context, child) {
            return Container(
              height: 6,
              width: 120 * _underlineAnimation.value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.purple.shade400,
                    Colors.pink.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSkillsGrid(ThemeData theme) {
    final skillsData = _getSkillsData();

    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(),
          crossAxisSpacing: Responsive.isMobile(context) ? 16 : 28,
          mainAxisSpacing: Responsive.isMobile(context) ? 16 : 28,
          childAspectRatio: Responsive.isMobile(context)
              ? 0.96
              : (Responsive.isTablet(context) ? 0.9 : 0.95),
        ),
        itemCount: skillsData.length,
        itemBuilder: (context, index) {
          return _buildEnhancedSkillCard(
            skillsData[index],
            theme,
            index,
          )
              .animate(delay: (index * 90).ms)
              .fadeIn(duration: 500.ms, curve: Curves.easeOutCubic)
              .slideY(
                  begin: 0.18,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.easeOutCubic)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }

  int _getCrossAxisCount() {
    if (Responsive.isMobile(context)) return 1;
    if (Responsive.isTablet(context)) return 2;
    return 3;
  }

  Widget _buildEnhancedSkillCard(
    Map<String, dynamic> skill,
    ThemeData theme,
    int index,
  ) {
    final isHovered = _hoverStates[index];

    return MouseRegion(
      onEnter: (_) => _onCardHover(index, true),
      onExit: (_) => _onCardHover(index, false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -8.0 : 0.0),
        padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 22.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isHovered
                ? [
                    const Color(0xFF242238),
                    const Color(0xFF151425),
                  ]
                : [
                    const Color(0xFF1C1A2A),
                    const Color(0xFF11101C),
                  ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHovered
                ? primaryColor.withOpacity(0.7)
                : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAnimatedIcon(skill, isHovered),
            const SizedBox(height: 16),
            _buildSkillTitle(skill, theme, isHovered),
            const SizedBox(height: 12),
            _buildSkillDescription(skill, theme, index),
            const SizedBox(height: 16),
            _buildEnhancedTechnologyTags(skill, theme, isHovered),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(Map<String, dynamic> skill, bool isHovered) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isHovered
              ? [
                  primaryColor.withOpacity(0.25),
                  secondaryColor.withOpacity(0.2),
                ]
              : [
                  primaryColor.withOpacity(0.12),
                  secondaryColor.withOpacity(0.06),
                ],
        ),
        border: Border.all(
          color: isHovered
              ? primaryColor.withOpacity(0.85)
              : primaryColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: isHovered
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Icon(
          skill['icon'] as IconData,
          size: 32,
          color: isHovered ? primaryColor : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSkillTitle(
      Map<String, dynamic> skill, ThemeData theme, bool isHovered) {
    return Text(
      skill['title'] as String,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.3,
        height: 1.25,
      ),
    );
  }

  Widget _buildSkillDescription(
      Map<String, dynamic> skill, ThemeData theme, int index) {
    return Text(
      skill['description'] as String,
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        color: Colors.white.withOpacity(0.7),
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
    );
  }

  Widget _buildEnhancedTechnologyTags(
      Map<String, dynamic> skill, ThemeData theme, bool isHovered) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: (skill['technologies'] as List<String>)
          .map((tech) => _buildGradientTechChip(
              tech, theme, skill['color'] as Color, isHovered))
          .toList(),
    );
  }

  Widget _buildGradientTechChip(
      String tech, ThemeData theme, Color accentColor, bool cardHovered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: cardHovered
            ? primaryColor.withOpacity(0.15)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardHovered
              ? primaryColor.withOpacity(0.6)
              : Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Text(
        tech,
        style: TextStyle(
          fontSize: 12,
          color: cardHovered ? primaryColor : Colors.white.withOpacity(0.85),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  void _onCardHover(int index, bool isHover) {
    if (mounted) {
      setState(() {
        _hoverStates[index] = isHover;
      });
    }
  }

  List<Map<String, dynamic>> _getSkillsData() {
    return [
      {
        'title': 'Real-time Communication',
        'description':
            'Advanced video calling, voice chat, and live streaming solutions with crystal clear quality and low latency',
        'icon': Icons.video_call_rounded,
        'color': Colors.white,
        'technologies': ['ZegoCloud', 'Agora', 'WebRTC', 'Socket.io'],
      },
      {
        'title': 'Cloud Integration',
        'description':
            'Seamless integration with modern cloud services, real-time databases, and scalable backend solutions',
        'icon': Icons.cloud_sync_rounded,
        'color': Colors.white,
        'technologies': ['Firebase', 'Supabase', 'AWS', 'REST APIs'],
      },
      {
        'title': 'Location & Navigation',
        'description':
            'Advanced mapping, real-time GPS tracking, and location-based services for delivery and mobility apps',
        'icon': Icons.location_on_rounded,
        'color': Colors.white,
        'technologies': ['Google Maps', 'Live Tracking', 'Geofencing'],
      },
      {
        'title': 'Smart Notifications',
        'description':
            'Intelligent push notifications, in-app messaging, and user engagement systems with personalization',
        'icon': Icons.notifications_active_rounded,
        'color': Colors.white,
        'technologies': ['FCM', 'OneSignal', 'Local Notifications'],
      },
      {
        'title': 'Payment Systems',
        'description':
            'Secure payment processing with multiple gateways, digital wallets, and subscription management',
        'icon': Icons.payment_rounded,
        'color': Colors.white,
        'technologies': ['Stripe', 'PayPal', 'Razorpay', 'Apple Pay'],
      },
      {
        'title': 'Architecture & State',
        'description':
            'Robust app architecture with efficient state management for scalable and maintainable applications',
        'icon': Icons.architecture_rounded,
        'color': Colors.white,
        'technologies': ['GetX', 'Provider', 'Bloc', 'Riverpod'],
      },
    ];
  }
}
