import 'dart:async';
import 'package:flutter/material.dart';
import 'scroll_entrance_section.dart';

/// Fades, slides, and smoothly scales a widget into view when its parent section enters the viewport.
/// Automatically resets when scrolled out of view and re-animates when scrolled back in.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final double beginScale;
  final bool autoStart;
  final String? detectorKey;

  const ScrollReveal({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 950),
    this.beginOffset = const Offset(0, 36),
    this.beginScale = 0.96,
    this.autoStart = false,
    this.detectorKey,
  }) : super(key: key);

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  Timer? _timer;
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = curve;
    _slide = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(
      begin: widget.beginScale,
      end: 1.0,
    ).animate(curve);

    if (widget.autoStart) {
      _wasVisible = true;
      _animateIn();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autoStart) return;

    final bool isVisible = SectionVisibilityScope.of(context);
    if (isVisible != _wasVisible) {
      _wasVisible = isVisible;
      if (isVisible) {
        _animateIn();
      } else {
        _reset();
      }
    }
  }

  void _animateIn() {
    _timer?.cancel();
    if (widget.delay == Duration.zero) {
      if (mounted) _controller.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted && _wasVisible) {
          _controller.forward();
        }
      });
    }
  }

  void _reset() {
    _timer?.cancel();
    if (mounted) {
      _controller.reset();
    }
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
          opacity: _fade.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: _slide.value,
            child: Transform.scale(
              scale: _scale.value,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
