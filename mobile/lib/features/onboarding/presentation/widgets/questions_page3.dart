import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'preparation_level_card.dart';

import '../bloc/onboarding_bloc.dart';

class QuestionPageThree extends StatelessWidget {
  const QuestionPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    void onLittleDedication() {
      context
          .read<OnboardingBloc>()
          .add(const DedicationTimeChangedEvent(dedicationTime: 0));
    }

    void onMediumDedication() {
      context
          .read<OnboardingBloc>()
          .add(const DedicationTimeChangedEvent(dedicationTime: 1));
    }

    void onMedHighDedication() {
      context
          .read<OnboardingBloc>()
          .add(const DedicationTimeChangedEvent(dedicationTime: 2));
    }

    void onHighDedication() {
      context
          .read<OnboardingBloc>()
          .add(const DedicationTimeChangedEvent(dedicationTime: 3));
    }

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          const Text(
            'How long do you plan to dedicate each day to studying?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocBuilder<OnboardingBloc, OnboardingAnswersState>(
            builder: (context, state) {
              final dedicatedTime = state.dedicationTime;
              return ListView(
                shrinkWrap: true,
                children: [
                  OnboardingCard(
                      onTap: onLittleDedication,
                      selected:
                          dedicatedTime == null ? false : dedicatedTime == 0,
                      imageAdress: 'assets/images/onboarding/hour_alarm.png',
                      text: 'Less than 1 hour'),
                  OnboardingCard(
                      onTap: onMediumDedication,
                      selected:
                          dedicatedTime == null ? false : dedicatedTime == 1,
                      imageAdress: 'assets/images/onboarding/hour_alarm.png',
                      text: '1-2 hours'),
                  OnboardingCard(
                      onTap: onMedHighDedication,
                      selected:
                          dedicatedTime == null ? false : dedicatedTime == 2,
                      imageAdress:
                          'assets/images/onboarding/two_hour_alarm.png',
                      text: '2-3 hours'),
                  OnboardingCard(
                      onTap: onHighDedication,
                      selected:
                          dedicatedTime == null ? false : dedicatedTime == 3,
                      imageAdress:
                          'assets/images/onboarding/three_hour_alarm.png',
                      text: 'More than 3 hours')
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
