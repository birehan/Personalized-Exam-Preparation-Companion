import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skill_bridge_mobile/features/home/presentation/widgets/count_down_item_for_national_exam.dart';

class CountDownCardForNationalExams extends StatefulWidget {
  const CountDownCardForNationalExams({
    super.key,
    required this.timeLeft,
  });

  final int timeLeft;

  @override
  State<CountDownCardForNationalExams> createState() =>
      _CountDownCardForNationalExamsState();
}

class _CountDownCardForNationalExamsState
    extends State<CountDownCardForNationalExams> {
  late Timer _timer;
  late final int _countDownDuration = 1800000;

  // @override
  // void initState() {
  //   super.initState();
  //   _countDownDuration = widget.timeLeft;
  //   if (_countDownDuration < 0) {
  //     _countDownDuration = 0;
  //   }

  //   _timer = Timer.periodic(
  //     const Duration(seconds: 1),
  //     (timer) {
  //       if (_countDownDuration > 0) {
  //         setState(() {
  //           _countDownDuration--;
  //         });
  //       } else {
  //         _timer.cancel();
  //       }
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final months = (_countDownDuration ~/ 2628000).toString().padLeft(2, '0');
    final days = (_countDownDuration ~/ 86400).toString().padLeft(2, '0');
    // final hours = ((timeLeft ~/ 3600) % 24).toString().padLeft(2, '0');
    // final minutes = ((timeLeft ~/ 60) % 60).toString().padLeft(2, '0');

    // final seconds = (timeLeft % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff306496),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CounrDownItemCard(
                    countDown: months,
                    label: AppLocalizations.of(context)!.month,
                  ),
                  CounrDownItemCard(
                    countDown: days,
                    label: AppLocalizations.of(context)!.days,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
