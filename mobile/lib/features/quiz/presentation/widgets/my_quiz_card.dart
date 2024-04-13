import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';

class MyQuizCard extends StatelessWidget {
  const MyQuizCard({
    super.key,
    required this.courseId,
    required this.isCompleted,
    required this.examName,
    required this.numberOfQuestions,
    required this.timeLeft,
    required this.examId,
    required this.isMock,
    required this.progress,
  });

  final String courseId;
  final bool isCompleted;
  final String examId;
  final String examName;
  final String timeLeft;
  final int numberOfQuestions;
  final bool isMock;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertDialogBloc, AlertDialogState>(
      listener: (context, state) {
        if (state is LearningQuizModeState &&
            state.status == AlertDialogStatus.loaded) {
          QuizQuestionPageRoute(
            courseId: courseId,
            quizId: state.examId!,
            $extra: state.questionMode!,
          ).go(context);
        }
      },
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => LearningQuizModeDialog(
              examId: examId,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black.withOpacity(0.05),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFF67D181)
                              : const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isCompleted ? 'COMPLETED' : 'ONGOING',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 50.w),
                        child: Text(
                          examName,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  UserScoreIndicatorWidget(progress: progress),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '$numberOfQuestions QUESTIONS',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFBAB5B5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFF8A8888),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeLeft,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF8A8888),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(2, 2, 6, 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF0072FF)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xFF0072FF),
                          size: 28,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          // isCompleted ? 'Analysis' : 'Resume',
                          isCompleted ? 'START' : 'Resume',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF0072FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
