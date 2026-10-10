import 'package:flutter/material.dart';

class CustomOutline extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;

  final double _width;
  final double _height;
  final EdgeInsetsGeometry _padding;

  CustomOutline({
    super.key,
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required double width,
    required double height,
    required EdgeInsetsGeometry padding,
  })  : _painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        _child = child,
        _width = width,
        _height = height,
        _padding = padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        width: _width,
        height: _height,
        padding: _padding,
        child: _child,
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double _radius;
  final double _strokeWidth;
  final Gradient _gradient;

  _GradientPainter({
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
  })  : _strokeWidth = strokeWidth,
        _radius = radius,
        _gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final double half = _strokeWidth / 2;
    final Rect strokeRect = Rect.fromLTWH(
      half,
      half,
      size.width - _strokeWidth,
      size.height - _strokeWidth,
    );

    _paint
      ..shader = _gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final double innerRadius = (_radius - half).clamp(0.0, double.infinity);
    canvas.drawRRect(
      RRect.fromRectAndRadius(strokeRect, Radius.circular(innerRadius)),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientPainter oldDelegate) =>
      oldDelegate._strokeWidth != _strokeWidth ||
      oldDelegate._radius != _radius ||
      oldDelegate._gradient != _gradient;
}
