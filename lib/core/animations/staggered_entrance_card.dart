import 'dart:async';
import 'package:flutter/material.dart';

class StaggeredEntranceCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final double offsetDistance;

  const StaggeredEntranceCard({
    Key? key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 90),
    this.duration = const Duration(milliseconds: 650),
    this.offsetDistance = 45.0,
  }) : super(key: key);

  @override
  State<StaggeredEntranceCard> createState() => _StaggeredEntranceCardState();
}

class _StaggeredEntranceCardState extends State<StaggeredEntranceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _timer;

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

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offsetDistance),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    final totalDelay = Duration(milliseconds: widget.index * widget.delay.inMilliseconds);
    _timer = Timer(totalDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
