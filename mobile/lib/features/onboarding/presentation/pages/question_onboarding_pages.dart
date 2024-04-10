import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/onboarding/presentation/widgets/questions_page_8.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/schoolInfoBloc/school_bloc.dart';
import '../../../../core/core.dart';

import '../../../features.dart';

class OnboardingQuestionPages extends StatefulWidget {
  const OnboardingQuestionPages({super.key});

  @override
  State<OnboardingQuestionPages> createState() =>
      _OnboardingQuestionPagesState();
}

class _OnboardingQuestionPagesState extends State<OnboardingQuestionPages> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    context.read<SchoolBloc>().add(GetSchoolInformationEvent());
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 5.h, left: 4.w, right: 4.w, bottom: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentIndex == 0
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color.fromARGB(0, 177, 52, 52),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _currentIndex - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                        ),
                      ),
                if (_currentIndex != 4)
                  SizedBox(
                    width: 60.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) /
                            4, // userProgress should be a double between 0.0 and 1.0
                        minHeight: 6,
                        backgroundColor: const Color(0xffE7F0EF),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xff18786A),
                        ),
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.transparent,
                  ),
                )
              ],
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: SizedBox(
                // height: _currentIndex == 6 ? 90.h : 75.h,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    QuestionPageOne(),
                    QuestionsPageTwo(),
                    QuestionPageThree(),
                    QuestionsPageFour(),
                    // Reminder: The pages below are commented for now:
                    // QuestionsPageFive(),
                    // OnboardingSchoolsPage(),
                    // QuestionsPageSix(),
                    // QuestionsPageSeven(),
                  ],
                ),
              ),
            ),

            BlocBuilder<OnboardingBloc, OnboardingAnswersState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (_currentIndex == 4 && !state.validResponse)
                      const Text(
                        'Please answer all the previous pages questions',
                        style: TextStyle(color: Colors.orange),
                      ),
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex == 4 && !state.validResponse) {
                          return;
                        } else if (_currentIndex >= 3) {
                          print(
                              'submittion is now on progress!...................');
                          context.read<OnboardingBloc>().add(
                                OnboardingQuestionsResponseSubmittedEvent(),
                              );
                        }
                        if (_currentIndex < 4) {
                          _pageController.animateToPage(
                            _currentIndex + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );

                          context.read<OnboardingBloc>().add(
                                OnContinueButtonPressedEvent(),
                              );
                        }
                      },
                      child: Container(
                        width: _currentIndex == 7 ? 0 : 40.w,
                        height: _currentIndex == 7 ? 0 : 6.h,
                        margin: EdgeInsets.only(top: 2.h),
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 6.w, vertical: 2.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: _currentIndex == 4 && !state.validResponse
                                ? Colors.grey
                                : const Color(0xff18786A)),
                        child: BlocConsumer<OnboardingBloc,
                            OnboardingAnswersState>(
                          listener: (context, state) {
                            if (state.responseSubmitted) {
                              CubeAnimationPageRoute().go(context);
                            }
                          },
                          builder: (context, state) {
                            if (state.responseSubmitting) {
                              return const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentIndex < 3
                                      ? 'Continue'
                                      : 'Let\'s start',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
            //     : const SizedBox()
          ],
        ),
      ),
    );
  }
}
