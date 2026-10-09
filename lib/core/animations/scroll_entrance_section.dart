import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scroll_provider.dart';

class ScrollEntranceSection extends StatefulWidget {
  final Widget child;
  final int index;
  final bool? slideFromRight;
  final Duration duration;
  final double slideOffset;

  const ScrollEntranceSection({
    Key? key,
    required this.child,
    required this.index,
    this.slideFromRight,
    this.duration = const Duration(milliseconds: 650),
    this.slideOffset = 35.0,
  }) : super(key: key);

  @override
  State<ScrollEntranceSection> createState() => _ScrollEntranceSectionState();
}

class _ScrollEntranceSectionState extends State<ScrollEntranceSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _fallbackTimer;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Alternate: odd index slides from right, even index slides from left
    final bool fromRight = widget.slideFromRight ?? (widget.index % 2 != 0);
    final double initialDx = widget.index == 0
        ? 0.0
        : (fromRight ? widget.slideOffset : -widget.slideOffset);
    final double initialDy = widget.index == 0 ? 25.0 : 20.0;

    _slideAnimation = Tween<Offset>(
      begin: Offset(initialDx, initialDy),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Home section (index 0) displays immediately
    if (widget.index == 0) {
      _triggerAnimation();
    } else {
      // Safety fallback: ensure section never stays invisible even if listener hiccups
      _fallbackTimer = Timer(const Duration(milliseconds: 3500), () {
        if (mounted && !_hasTriggered) {
          _triggerAnimation();
        }
      });
    }
  }

  void _triggerAnimation() {
    if (_hasTriggered) return;
    _hasTriggered = true;
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollProvider = Provider.of<ScrollProvider>(context, listen: true);
    if (scrollProvider.isVisible(widget.index) && !_hasTriggered) {
      _triggerAnimation();
    }
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
