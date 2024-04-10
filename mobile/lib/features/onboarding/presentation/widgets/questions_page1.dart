import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../bloc/onboarding_bloc.dart';
import 'preparation_level_card.dart';

class QuestionPageOne extends StatelessWidget {
  const QuestionPageOne({super.key});
  @override
  Widget build(BuildContext context) {
    void onVeryPrepared() {
      context
          .read<OnboardingBloc>()
          .add(const PreparationLevelChangedEvent(preparationLevel: 0));
    }

    void onMediumPrepared() {
      context
          .read<OnboardingBloc>()
          .add(const PreparationLevelChangedEvent(preparationLevel: 1));
    }

    void onNotPrepared() {
      context
          .read<OnboardingBloc>()
          .add(const PreparationLevelChangedEvent(preparationLevel: 2));
    }

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          const Text(
            '👋 Hi, tell us about yourself and how prepared you are for the exam?',
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
              return ListView(
                shrinkWrap: true,
                children: [
                  OnboardingCard(
                      onTap: onVeryPrepared,
                      selected: state.preparationLevel == null
                          ? false
                          : state.preparationLevel == 0,
                      imageAdress: 'assets/images/onboarding/smile.png',
                      text: 'Very prepared'),
                  OnboardingCard(
                      onTap: onMediumPrepared,
                      selected: state.preparationLevel == null
                          ? false
                          : state.preparationLevel == 1,
                      imageAdress: 'assets/images/onboarding/nutral.png',
                      text: 'Somewhat prepared'),
                  OnboardingCard(
                      onTap: onNotPrepared,
                      selected: state.preparationLevel == null
                          ? false
                          : state.preparationLevel == 2,
                      imageAdress: 'assets/images/onboarding/worried.png',
                      text: 'Not prepared at all')
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
