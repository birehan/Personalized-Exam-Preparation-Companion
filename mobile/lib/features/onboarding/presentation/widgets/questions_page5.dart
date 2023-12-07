import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'preparation_level_card.dart';

import '../bloc/onboarding_bloc.dart';

class QuestionsPageFive extends StatelessWidget {
  const QuestionsPageFive({super.key});

  @override
  Widget build(BuildContext context) {
    void onNaturalSelect() {
      context.read<OnboardingBloc>().add(const StreamChangedEvent(stream: 0));
    }

    void onSocialSelect() {
      context.read<OnboardingBloc>().add(const StreamChangedEvent(stream: 1));
    }

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: const Text(
              'Which stream are you studying?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocBuilder<OnboardingBloc, OnboardingAnswersState>(
            builder: (context, state) {
              final stream = state.stream;
              return ListView(
                shrinkWrap: true,
                children: [
                  OnboardingCard(
                      onTap: onNaturalSelect,
                      selected: stream == null ? false : stream == 0,
                      imageAdress:
                          'assets/images/onboarding/natural_science.png',
                      text: 'Natural Science'),
                  OnboardingCard(
                      onTap: onSocialSelect,
                      selected: stream == null ? false : stream == 1,
                      imageAdress:
                          'assets/images/onboarding/socrial_science.png',
                      text: 'Social Science'),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
