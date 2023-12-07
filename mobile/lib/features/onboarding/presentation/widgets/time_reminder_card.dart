import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/onboarding_bloc.dart';
import 'time_reminder_spinner.dart';

class TimeReminderCard extends StatefulWidget {
  const TimeReminderCard({super.key});

  @override
  State<TimeReminderCard> createState() => _TimeReminderCardState();
}

class _TimeReminderCardState extends State<TimeReminderCard> {
  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    DateTime selectedDateTime = DateTime.now();
    return TimePickerSpinner(
      time: DateTime.now(),
      amText: localizations.anteMeridiemAbbreviation,
      pmText: localizations.postMeridiemAbbreviation,
      // isShowSeconds: false,
      is24HourMode: false,
      // minutesInterval: 1,
      // secondsInterval: 1,
      // isForce2Digits: false,
      onTimeChange: (value) {
        DateTime tempDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          value.hour,
          value.minute,
        );

        selectedDateTime = tempDateTime;
        context
            .read<OnboardingBloc>()
            .add(ReminderTimeChangedEvent(reminderTime: tempDateTime));
      },
    );
  }
}
