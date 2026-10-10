import 'package:flutter/material.dart';
import 'package:mysite/app/widgets/custom_outline.dart';
import 'package:mysite/core/theme/app_theme.dart';

class ZoomAnimations extends StatefulWidget {
  final double? size;
  const ZoomAnimations({super.key, this.size});

  @override
  State<ZoomAnimations> createState() => _ZoomAnimationsState();
}

class _ZoomAnimationsState extends State<ZoomAnimations>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _controller2;
  late final Animation<AlignmentGeometry> _alignAnimation;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.18, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _sizeAnimation = Tween<double>(begin: 0.76, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat(reverse: true);

    _alignAnimation = Tween<AlignmentGeometry>(
      begin: const Alignment(0, -0.05),
      end: const Alignment(0, 0.05),
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    final double avatarSize = widget.size ??
        (screenSize.width * 0.22).clamp(200.0, 320.0);

    return SizedBox(
      width: avatarSize + 24,
      height: avatarSize + 24,
      child: AlignTransition(
        alignment: _alignAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _sizeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: theme.secondaryColor.withValues(alpha: 0.25),
                      blurRadius: 48,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: CustomOutline(
                  strokeWidth: 4,
                  radius: avatarSize / 2,
                  padding: const EdgeInsets.all(4),
                  width: avatarSize,
                  height: avatarSize,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.secondaryColor,
                      theme.secondaryColor.withValues(alpha: 0.4),
                      theme.primaryColor.withValues(alpha: 0.4),
                      theme.primaryColor,
                    ],
                    stops: const [0.1, 0.4, 0.7, 1.0],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.8),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        image: ResizeImage(
                          AssetImage('assets/imgs/IMG0107.png'),
                          width: 500,
                          height: 500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
