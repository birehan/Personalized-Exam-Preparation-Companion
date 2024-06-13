import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
// import '../../../features.dart';

class QuestionBottomNavBar extends StatelessWidget {
  const QuestionBottomNavBar({
    super.key,
    required this.index,
    required this.totalQuestions,
    required this.goTo,
    required this.onSubmit,
    required this.onSaveScore,
    required this.questionTitle,
    required this.questionMode,
    this.showQuestionTitle = true,
  });

  final String questionTitle;
  final int index;
  final int totalQuestions;
  final Function(int) goTo;
  final Function onSubmit;
  final Function onSaveScore;
  final QuestionMode questionMode;
  final bool showQuestionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showQuestionTitle
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 45.w,
                      child: Text(
                        capitalizeFirstLetterOfEachWord(questionTitle),
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF363636),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 45.w,
                      child: Text(
                        '${index + 1} out of $totalQuestions questions',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF717171),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Container(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  goTo(index - 1);
                },
                icon: Icon(
                  index == 0 ? null : Icons.arrow_back,
                  size: 32,
                  color: const Color(0xFF0072FF),
                ),
              ),
              const SizedBox(width: 16),
              index == totalQuestions - 1
                  ? questionMode == QuestionMode.learning ||
                          questionMode == QuestionMode.quiz
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0072FF),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            onSubmit();
                            onSaveScore();
                          },
                          child: Text(
                            'SUBMIT', //! this has to be changed
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0072FF),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (!showQuestionTitle) {
                              context
                                  .read<FetchDailyQuizForAnalysisBloc>()
                                  .add(FetchDailyQuizForAnalysisInitialEvent());
                              context
                                  .read<FetchDailyQuizBloc>()
                                  .add(const FetchDailyQuizEvent());
                            }
                            context.pop();
                          },
                          child: Text(
                            'Done', //! this has to be changed
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                  : IconButton(
                      onPressed: () {
                        goTo(index + 1);
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 32,
                        color: Color(0xFF0072FF),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
