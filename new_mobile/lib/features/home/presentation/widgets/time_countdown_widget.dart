// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features.dart';

class TimeCountDownWidget extends StatefulWidget {
  const TimeCountDownWidget({
    Key? key,
    required this.targetDate,
  }) : super(key: key);

  final DateTime targetDate;

  @override
  State<TimeCountDownWidget> createState() => _TimeCountDownWidgetState();
}

class _TimeCountDownWidgetState extends State<TimeCountDownWidget> {
  late Timer _timer;
  late int _countDownDuration;

  @override
  void initState() {
    super.initState();
    _countDownDuration = widget.targetDate.difference(DateTime.now()).inSeconds;
    if (_countDownDuration < 0) {
      _countDownDuration = 0;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDownDuration > 0) {
        setState(() {
          _countDownDuration--;
        });
      } else {
        _timer.cancel();
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
    final months = (_countDownDuration ~/ 2628000).toString().padLeft(2, '0');
    final weeks =
        ((_countDownDuration % 2628000) ~/ 604800).toString().padLeft(2, '0');
    final days =
        ((_countDownDuration % 604800) ~/ 86400).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0072FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.time_left_till_your_exam,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimeCounterWidget(
                countDownTime: months,
                timeFormat: int.parse(months) > 1
                    ? AppLocalizations.of(context)!.months
                    : AppLocalizations.of(context)!.month,
              ),
              TimeCounterWidget(
                countDownTime: weeks,
                timeFormat: int.parse(weeks) > 1
                    ? AppLocalizations.of(context)!.weeks
                    : AppLocalizations.of(context)!.week,
              ),
              TimeCounterWidget(
                countDownTime: days,
                timeFormat: int.parse(days) > 1
                    ? AppLocalizations.of(context)!.days
                    : AppLocalizations.of(context)!.day,
              ),
            ],
          )
        ],
      ),
    );
  }
}
