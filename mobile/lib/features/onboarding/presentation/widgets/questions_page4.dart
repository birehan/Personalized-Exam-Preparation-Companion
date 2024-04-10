import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'preparation_level_card.dart';

import '../bloc/onboarding_bloc.dart';

class QuestionsPageFour extends StatelessWidget {
  const QuestionsPageFour({super.key});

  @override
  Widget build(BuildContext context) {
    void onAcadamicSelect() {
      context
          .read<OnboardingBloc>()
          .add(const UserMotiveChangedEvent(userMotive: 0));
    }

    void onPersonalGrowthSelect() {
      context
          .read<OnboardingBloc>()
          .add(const UserMotiveChangedEvent(userMotive: 1));
    }

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: const Text(
              'What motivates you to build good study habits?',
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
              final userMotive = state.userMotive;
              return ListView(
                shrinkWrap: true,
                children: [
                  OnboardingCard(
                      onTap: onAcadamicSelect,
                      selected: userMotive == null ? false : userMotive == 0,
                      imageAdress: 'assets/images/onboarding/mortarboard.png',
                      text: 'Achieving academic success'),
                  OnboardingCard(
                      onTap: onPersonalGrowthSelect,
                      selected: userMotive == null ? false : userMotive == 1,
                      imageAdress:
                          'assets/images/onboarding/personal_growth.png',
                      text: 'Personal growth and improvement'),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
