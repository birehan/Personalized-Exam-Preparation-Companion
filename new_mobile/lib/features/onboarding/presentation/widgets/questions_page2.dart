import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../bloc/onboarding_bloc.dart';
import 'preparation_level_card.dart';

class QuestionsPageTwo extends StatelessWidget {
  const QuestionsPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    void onReadingSelected() {
      context
          .read<OnboardingBloc>()
          .add(const PreparationMethodChangedEvent(preparationMethod: 0));
    }

    void onIntereactiveSelected() {
      context
          .read<OnboardingBloc>()
          .add(const PreparationMethodChangedEvent(preparationMethod: 1));
    }

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: const Text(
              'What is your preferred method of studying?',
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
              return ListView(
                shrinkWrap: true,
                children: [
                  OnboardingCard(
                      onTap: onReadingSelected,
                      selected: state.preparationMethod == null
                          ? false
                          : state.preparationMethod == 0,
                      imageAdress: 'assets/images/onboarding/notes.png',
                      text: 'Reading and taking notes'),
                  OnboardingCard(
                      onTap: onIntereactiveSelected,
                      selected: state.preparationMethod == null
                          ? false
                          : state.preparationMethod == 1,
                      imageAdress: 'assets/images/onboarding/test.png',
                      text: 'Interactive exercises and practice'),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
