import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home.dart';

class CountDownCard extends StatefulWidget {
  const CountDownCard({
    super.key,
    required this.targetDate,
  });

  final DateTime targetDate;

  @override
  State<CountDownCard> createState() => _CountDownCardState();
}

class _CountDownCardState extends State<CountDownCard> {
  late Timer _timer;
  late int _countDownDuration;

  @override
  void initState() {
    super.initState();
    _countDownDuration = widget.targetDate.difference(DateTime.now()).inSeconds;
    if (_countDownDuration < 0) {
      _countDownDuration = 0;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_countDownDuration > 0) {
          setState(() {
            _countDownDuration--;
          });
        } else {
          _timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = (_countDownDuration ~/ 86400).toString().padLeft(2, '0');
    final hours =
        ((_countDownDuration ~/ 3600) % 24).toString().padLeft(2, '0');
    final minutes =
        ((_countDownDuration ~/ 60) % 60).toString().padLeft(2, '0');

    // final seconds = (_countDownDuration % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF18786A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Are you ready for exam?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CounterColumn(
                      countDown: days,
                      label: 'Days',
                    ),
                    CounterColumn(
                      countDown: hours,
                      label: 'Hours',
                    ),
                    CounterColumn(
                      countDown: minutes,
                      label: 'Minutes',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
