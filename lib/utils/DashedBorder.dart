import 'package:flutter/material.dart';

class DashedBorder extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorder({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    _drawDashedLine(
        canvas, const Offset(0, 0), Offset(size.width, 0), paint); // Top
    _drawDashedLine(canvas, Offset(0, size.height),
        Offset(size.width, size.height), paint); // Bottom
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    double x = start.dx;
    while (x < end.dx) {
      canvas.drawLine(
          Offset(x, start.dy), Offset(x + dashWidth, start.dy), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
