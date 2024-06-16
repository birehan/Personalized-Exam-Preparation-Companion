import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class QuizListCard extends StatelessWidget {
  const QuizListCard({
    super.key,
    required this.quizId,
    required this.title,
    required this.status,
    required this.questionLength,
    required this.timeTaken,
    required this.progress,
  });

  final String quizId;
  final String title;
  final bool status;
  final double progress;
  final int questionLength;
  final int timeTaken;

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizQuestionBloc, QuizQuestionState>(
      listener: (context, state) {
        if (state is GetQuizByIdState &&
            state.status == QuizQuestionStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar(state.failure!.errorMessage));
        } else if (state is GetQuizByIdState &&
            state.status == QuizQuestionStatus.loaded) {
          // TODO: Navigation
          // context.push(
          //   AppRoutes.quizExamPage,
          //   extra: QuizExamQuestionPageParams(
          //     quizQuestion: state.quizQuestion!,
          //     isQuizMode: true,
          //     stackHeight: 1,
          //   ),
          // );
        }
      },
      child: buildWidget(context),
    );
  }

  InkWell buildWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<QuizQuestionBloc>().add(
              GetQuizByIdEvent(
                quizId: quizId,
                isRefreshed: false,
              ),
            );
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE8E8E8),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  UserScoreIndicatorWidget(progress: progress),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  capitalizeFirstLetterOfEachWord(title),
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomChipWidget(
                                status: status,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '$questionLength questions',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF848484),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF848484),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$timeTaken mins',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF848484),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
