import 'dart:math';

import 'package:flutter/material.dart';

class FillingBar extends StatefulWidget {
  const FillingBar({
    super.key,
    required this.progress,
    required this.width,
    required this.height,
    required this.strokeWidth,
  });

  final double width;
  final double height;
  final double progress;
  final double strokeWidth;

  @override
  State<FillingBar> createState() => _FillingBarState();
}

class _FillingBarState extends State<FillingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress / 100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: const Color(0xFFD9D9D9),
                width: widget.strokeWidth,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: _CircularProgressPainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.transparent,
                      // color: const Color(0xFFD9D9D9),
                      width: widget.strokeWidth,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    // const strokeWidth = strokeWidth;
    const startAngle = pi / 2;
    final sweepAngle = 2 * pi * progress;

    final paint = Paint()
      ..color = const Color(0xFF18786A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
