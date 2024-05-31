import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../home.dart';

class CountDownCard extends StatelessWidget {
  const CountDownCard({
    super.key,
    required this.timeLeft,
    required this.forContest,
  });

  final int timeLeft;
  final bool forContest;

  @override
  Widget build(BuildContext context) {
    final days = (timeLeft ~/ 86400).toString().padLeft(2, '0');
    final hours = ((timeLeft ~/ 3600) % 24).toString().padLeft(2, '0');
    final minutes = ((timeLeft ~/ 60) % 60).toString().padLeft(2, '0');

    final seconds = (timeLeft % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: forContest ? Colors.transparent : const Color(0xFF18786A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!forContest)
                  Text(
                    AppLocalizations.of(context)!.are_you_ready_for_exam,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (!forContest) const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CounterColumn(
                      countDown: days,
                      label: AppLocalizations.of(context)!.days,
                    ),
                    CounterColumn(
                      countDown: hours,
                      label: AppLocalizations.of(context)!.hours,
                    ),
                    CounterColumn(
                      countDown: minutes,
                      label: AppLocalizations.of(context)!.minutes,
                    ),
                    CounterColumn(
                      countDown: seconds,
                      label: AppLocalizations.of(context)!.seconds,
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
