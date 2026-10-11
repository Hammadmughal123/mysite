import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysite/core/color/colors.dart';

import 'package:mysite/core/res/responsive.dart';

class ParticleField extends StatefulWidget {
  const ParticleField({super.key});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_Particle> _particles;
  final _random = Random(7);
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final bool isMobile = Responsive.isMobile(context);
      final int count = isMobile ? 16 : 36;

      _particles = List.generate(count, (_) {
        return _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          radius: 1.0 + _random.nextDouble() * 1.5,
          dx: (_random.nextDouble() - 0.48) * 0.022,
          dy: (_random.nextDouble() - 0.52) * 0.026,
          opacity: 0.18 + _random.nextDouble() * 0.35,
          pink: _random.nextBool(),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) return const SizedBox.shrink();
    if (!_initialized) return const SizedBox.shrink();

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _ParticlePainter(_particles, _controller.value),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  final double radius;
  final double dx;
  final double dy;
  final double opacity;
  final bool pink;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.opacity,
    required this.pink,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  static final Paint _paint = Paint();

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      var x = (p.x + p.dx * t * 24) % 1.0;
      var y = (p.y + p.dy * t * 24) % 1.0;
      if (x < 0) x += 1;
      if (y < 0) y += 1;

      _paint.color = (p.pink ? primaryColor : secondaryColor)
          .withValues(alpha: p.opacity);

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.radius,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
