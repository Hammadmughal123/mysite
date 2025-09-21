import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/res/responsive.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({Key? key}) : super(key: key);

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;
  late Animation<double> _titleAnimation;
  late Animation<double> _timelineAnimation;

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

    // Title animation
    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
    ));

    // Timeline animation
    _timelineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
    ));

    // Card controllers
    final experienceData = _getExperienceData();
    _cardControllers = List.generate(
      experienceData.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _cardAnimations = _cardControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();
  }

  void _startAnimations() async {
    _mainAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 600));

    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _cardControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.transparent,
            Colors.black.withOpacity(0.1),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 20 : 60,
          vertical: 80,
        ),
        child: Column(
          children: [
            _buildEnhancedHeader(theme),
            const SizedBox(height: 80),
            if (Responsive.isDesktop(context))
              _buildDesktopExperience(theme)
            else
              _buildMobileExperience(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme) {
    return AnimatedBuilder(
      animation: _titleAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Transform.translate(
              offset: Offset(0, 40 * (1 - _titleAnimation.value)),
              child: Opacity(
                opacity: _titleAnimation.value.clamp(0.0, 1.0),
                child: Text(
                  'My Experience',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 36 : 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.2,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Transform.translate(
              offset: Offset(0, 30 * (1 - _titleAnimation.value)),
              child: Opacity(
                opacity: _titleAnimation.value.clamp(0.0, 1.0),
                child: Text(
                  'My journey through different companies and projects',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 16 : 18,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Enhanced underline
            Container(
              height: 4,
              width: 100 * _titleAnimation.value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade400,
                    Colors.pink.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopExperience(ThemeData theme) {
    final experienceData = _getExperienceData();

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Stack(
        children: [
          // Animated Timeline Line
          AnimatedBuilder(
            animation: _timelineAnimation,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                top: 40,
                child: Center(
                  child: Container(
                    width: 3,
                    height: (experienceData.length * 250).toDouble() *
                        _timelineAnimation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple.withOpacity(0.8),
                          Colors.purple.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          ),

          // Experience Cards
          Column(
            children: experienceData.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> experience = entry.value;
              bool isLeft = index % 2 == 0;

              return AnimatedBuilder(
                animation: _cardAnimations[index],
                builder: (context, child) {
                  final animValue =
                      _cardAnimations[index].value.clamp(0.0, 1.0);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 60),
                    child: Transform.translate(
                      offset: Offset(
                        isLeft ? -50 * (1 - animValue) : 50 * (1 - animValue),
                        0,
                      ),
                      child: Opacity(
                        opacity: animValue,
                        child: _buildDesktopExperienceCard(
                          experience: experience,
                          isLeft: isLeft,
                          theme: theme,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopExperienceCard({
    required Map<String, dynamic> experience,
    required bool isLeft,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        // Left content or spacer
        if (isLeft)
          Expanded(
            flex: 5,
            child: _buildEnhancedExperienceContent(
              experience: experience,
              theme: theme,
              alignment: CrossAxisAlignment.end,
            ),
          )
        else
          const Expanded(flex: 5, child: SizedBox()),

        // Timeline dot
        Container(
          width: 80,
          child: Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade400,
                    Colors.pink.shade400,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),

        // Right content or spacer
        if (!isLeft)
          Expanded(
            flex: 5,
            child: _buildEnhancedExperienceContent(
              experience: experience,
              theme: theme,
              alignment: CrossAxisAlignment.start,
            ),
          )
        else
          const Expanded(flex: 5, child: SizedBox()),
      ],
    );
  }

  Widget _buildEnhancedExperienceContent({
    required Map<String, dynamic> experience,
    required ThemeData theme,
    required CrossAxisAlignment alignment,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900.withOpacity(0.8),
            Colors.grey.shade800.withOpacity(0.6),
            Colors.grey.shade900.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          // Company and Type
          Row(
            mainAxisAlignment: alignment == CrossAxisAlignment.start
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (alignment == CrossAxisAlignment.end) ...[
                _buildTypeChip(experience['type']),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  experience['company'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                  textAlign: alignment == CrossAxisAlignment.start
                      ? TextAlign.left
                      : TextAlign.right,
                ),
              ),
              if (alignment == CrossAxisAlignment.start) ...[
                const SizedBox(width: 12),
                _buildTypeChip(experience['type']),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Position
          Text(
            experience['position'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.purple.shade300,
              letterSpacing: -0.2,
            ),
            textAlign: alignment == CrossAxisAlignment.start
                ? TextAlign.left
                : TextAlign.right,
          ),

          const SizedBox(height: 8),

          // Duration
          Text(
            experience['duration'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
            textAlign: alignment == CrossAxisAlignment.start
                ? TextAlign.left
                : TextAlign.right,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            experience['description'],
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
              letterSpacing: 0.1,
            ),
            textAlign: alignment == CrossAxisAlignment.start
                ? TextAlign.left
                : TextAlign.right,
          ),

          const SizedBox(height: 20),

          // Technologies
          Wrap(
            alignment: alignment == CrossAxisAlignment.start
                ? WrapAlignment.start
                : WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: (experience['technologies'] as List<String>)
                .map((tech) => _buildEnhancedTechChip(tech))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.pink.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildEnhancedTechChip(String tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        tech,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildMobileExperience(ThemeData theme) {
    final experienceData = _getExperienceData();

    return Column(
      children: experienceData.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> experience = entry.value;
        bool isLast = index == experienceData.length - 1;

        return AnimatedBuilder(
          animation: _cardAnimations[index],
          builder: (context, child) {
            final animValue = _cardAnimations[index].value.clamp(0.0, 1.0);

            return Transform.translate(
              offset: Offset(30 * (1 - animValue), 0),
              child: Opacity(
                opacity: animValue,
                child: _buildMobileExperienceWithTimeline(
                  experience: experience,
                  theme: theme,
                  isLast: isLast,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildMobileExperienceWithTimeline({
    required Map<String, dynamic> experience,
    required ThemeData theme,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Column
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade400,
                    Colors.pink.shade400,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 140,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.withOpacity(0.6),
                      Colors.purple.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),

        const SizedBox(width: 20),

        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade900.withOpacity(0.8),
                  Colors.grey.shade800.withOpacity(0.6),
                  Colors.grey.shade900.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.purple.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        experience['company'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    _buildTypeChip(experience['type']),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  experience['position'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade300,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  experience['duration'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  experience['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (experience['technologies'] as List<String>)
                      .map((tech) => _buildEnhancedTechChip(tech))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getExperienceData() {
    return [
      {
        'company': 'DigixValley Pvt Ltd',
        'position': 'Flutter Developer',
        'duration': '1.5 Years',
        'type': 'Full-time',
        'description':
            'Developed and maintained multiple cross-platform mobile applications using Flutter framework. Collaborated with design and backend teams to deliver high-quality user experiences.',
        'technologies': ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
      },
      {
        'company': 'Funzoft',
        'position': 'Mobile App Developer',
        'duration': '7 Months',
        'type': 'Full-time',
        'description':
            'Focused on mobile application development with emphasis on performance optimization and user interface design. Worked on various client projects and enhanced existing applications.',
        'technologies': [
          'Flutter',
          'Mobile Development',
          'UI/UX',
          'API Integration'
        ],
      },
      {
        'company': 'OrienTechz',
        'position': 'Flutter Developer Intern',
        'duration': 'Internship',
        'type': 'Part-time',
        'description':
            'Started my professional journey as an intern, learning industry best practices and contributing to real-world projects. Gained valuable experience in mobile app development.',
        'technologies': ['Flutter', 'Dart', 'Learning', 'Team Collaboration'],
      },
    ];
  }
}
