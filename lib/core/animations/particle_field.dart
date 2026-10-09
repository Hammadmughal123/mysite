import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysite/core/color/colors.dart';

class ParticleField extends StatefulWidget {
  const ParticleField({Key? key}) : super(key: key);

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
    _particles = List.generate(36, (_) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: 1.2 + _random.nextDouble() * 2.2,
        dx: (_random.nextDouble() - 0.5) * 0.018,
        dy: (_random.nextDouble() - 0.5) * 0.022,
        opacity: 0.18 + _random.nextDouble() * 0.35,
        pink: _random.nextBool(),
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      var x = (p.x + p.dx * t * 20) % 1.0;
      var y = (p.y + p.dy * t * 20) % 1.0;
      if (x < 0) x += 1;
      if (y < 0) y += 1;
      final paint = Paint()
        ..color =
            (p.pink ? primaryColor : secondaryColor).withOpacity(p.opacity);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
