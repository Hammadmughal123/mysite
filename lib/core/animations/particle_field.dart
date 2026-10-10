import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysite/core/color/colors.dart';

class ParticleField extends StatefulWidget {
  const ParticleField({super.key});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _random = Random(7);

  @override
  void initState() {
    super.initState();
    // 130 particles, small and crisp, lively smooth movement
    _particles = List.generate(130, (_) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: 1.0 + _random.nextDouble() * 1.6, // Choty crisp particles
        dx: (_random.nextDouble() - 0.48) * 0.030, // Faster, visible motion
        dy: (_random.nextDouble() - 0.52) * 0.034,
        opacity: 0.25 + _random.nextDouble() * 0.48, // Clearly visible
        pink: _random.nextBool(),
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
