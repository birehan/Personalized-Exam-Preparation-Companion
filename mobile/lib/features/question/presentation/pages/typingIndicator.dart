import 'dart:async';

import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  int _dotCount = 0;
  bool _isTyping = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    const interval = Duration(milliseconds: 400);

    _timer = Timer.periodic(interval, (Timer timer) {
      if (mounted) {
        setState(() {
          _isTyping = !_isTyping;
          if (!_isTyping) {
            _dotCount = (_dotCount + 1) % 4;
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // for (int j = 0; j < 3; j++)
          for (int i = 0; i < 3; i++)
            AnimatedContainer(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _isTyping && _dotCount >= i
                    ? Colors.grey.withOpacity(.4)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              duration: const Duration(milliseconds: 400),
            ),
        ],
      ),
    );
  }
}
