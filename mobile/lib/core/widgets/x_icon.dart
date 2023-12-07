import 'package:flutter/material.dart';

class XIcon extends StatelessWidget {
  final Color color;
  final double size;

  const XIcon({
    super.key,
    required this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _XPainter(color),
    );
  }
}

class _XPainter extends CustomPainter {
  final Color color;

  _XPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
