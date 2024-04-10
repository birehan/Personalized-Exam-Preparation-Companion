import 'package:flutter/material.dart';

class FillingStarIcons extends StatefulWidget {
  const FillingStarIcons({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  State<FillingStarIcons> createState() => _FillingStarIconsState();
}

class _FillingStarIconsState extends State<FillingStarIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<double> _animation1;

  late AnimationController _controller2;
  late Animation<double> _animation2;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    // animation one
    _controller1 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation1 = Tween<double>(
      begin: 0,
      end: widget.progress / 33,
    ).animate(_controller1);

    // animation two
    _controller2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation2 = Tween<double>(
      begin: 0,
      end: (widget.progress / 33) - 1,
    ).animate(_controller2);

    // animation three
    _controller3 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation3 = Tween<double>(
      begin: 0,
      end: (widget.progress / 33) - 2,
    ).animate(_controller3);

    // start the animation
    _controller1.forward().then((_) {
      _controller2.forward().then((_) {
        _controller3.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FillingStarIcon(animation: _animation1),
        FillingStarIcon(animation: _animation2),
        FillingStarIcon(animation: _animation3),
      ],
    );
  }
}

class FillingStarIcon extends StatelessWidget {
  final Animation<double> animation;

  const FillingStarIcon({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            const Icon(
              Icons.star,
              size: 32,
              color: Color(0xFFD9D9D9),
            ),
            ClipRect(
              clipper: _FillingStarClipper(animation.value),
              child: const Icon(
                Icons.star,
                size: 32,
                color: Color(0xFFFEA800),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FillingStarClipper extends CustomClipper<Rect> {
  final double fillPercentage;

  _FillingStarClipper(this.fillPercentage);

  @override
  Rect getClip(Size size) {
    final fillWidth = size.width * fillPercentage;
    return Rect.fromLTRB(0, 0, fillWidth, size.height);
  }

  @override
  bool shouldReclip(_FillingStarClipper oldClipper) {
    return oldClipper.fillPercentage != fillPercentage;
  }
}
