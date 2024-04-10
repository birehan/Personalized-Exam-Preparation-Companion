import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';
import '../bloc/onboarding_bloc.dart';
import 'time_reminder_card.dart';

class QuestionsPageSeven extends StatelessWidget {
  const QuestionsPageSeven({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingAnswersState>(
      listener: (context, state) {
        if (state.responseSubmitted) {
          context.push(AppRoutes.cubeRotateLoadingPage);
        }
      }, 
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Set a reminder to increase your success rate by nearly 63%!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const TimeReminderCard(),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    context.read<OnboardingBloc>().add(
                          OnboardingQuestionsResponseSubmittedEvent(),
                        );
                  },
                  child: Container(
                    width: 40.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xff18786A),
                    ),
                    child: BlocBuilder<OnboardingBloc, OnboardingAnswersState>(
                      builder: (context, state) {
                        if (state.responseSubmitting) {
                          return const Center(
                            child: CustomProgressIndicator(
                              size: 20,
                              color: Colors.white,
                            ),
                          );
                        }
                        return const Text(
                          'Set Now',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                TextButton(
                    onPressed: () {
                      //! if the user has not set the reminder time set it null
                      // context.read<OnboardingBloc>().add(
                      //      ReminderTimeChangedEvent(reminderTime: null));
                      context.read<OnboardingBloc>().add(
                            OnboardingQuestionsResponseSubmittedEvent(),
                          );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
