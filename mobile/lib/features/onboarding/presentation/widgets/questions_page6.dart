import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/constants/constants.dart';
import '../bloc/onboarding_bloc.dart';
import 'subjects_card.dart';

import '../../domain/entities/subjects_entity.dart';

class QuestionsPageSix extends StatelessWidget {
  const QuestionsPageSix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: const Text(
              'Are there specific subjects you find more challenging?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: SizedBox(
              width: 70.w,
              child: BlocBuilder<OnboardingBloc, OnboardingAnswersState>(
                builder: (context, state) {
                  final selectedSubjects = state.subjectsToCover;
                  final userOnboardingState =
                      context.read<OnboardingBloc>().state;

                  List<SubjectsEntity> subjects =
                      userOnboardingState.stream == null ||
                              userOnboardingState.stream == 0
                          ? naturalSubjects
                          : socialSubjects;
                  
                  return GridView.builder(
                    itemCount: subjects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 2.h,
                      childAspectRatio: .75,
                      crossAxisSpacing: 2.w,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return SubjectsCard(
                          image: subjects[index].image,
                          title: subjects[index].title,
                          onTap: () {
                            context.read<OnboardingBloc>().add(
                                  SubjectsChangedEvent(subjectIndex: index),
                                );
                          },
                          selected: selectedSubjects.contains(index));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
