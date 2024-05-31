import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/mock_exam/presentation/pages/mock_exam_separated_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class RecommendedMockCard extends StatelessWidget {
  const RecommendedMockCard(
      {super.key,
      required this.iconBackgroundColor,
      required this.icon,
      required this.examId,
      required this.examYear,
      required this.subject,
      required this.image,
      required this.numberOfQuestions});

  final Color iconBackgroundColor;
  final IconData icon;
  final String examId;
  final String examYear;
  final String subject;
  final String image;
  final int numberOfQuestions;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertDialogBloc, AlertDialogState>(
      listener: (context, state) {
        if (state is LearningQuizModeState &&
            state.status == AlertDialogStatus.loaded) {
          context
              .read<UserMockBloc>()
              .add(AddMockToUserMockEvent(mockId: state.examId!));

          // RecommendedMockPageRoute(
          //   mockId: state.examId!,
          //   $extra: state.questionMode!,
          // ).go(context);
          MyExamsMockQuestionPageRoute(
                  mockId: state.examId ?? '',
                  $extra: MockExamQuestionPageParams(
                      completed: true,
                      questionNumber: state.questionNumber!,
                      mockId: state.examId!,
                      questionMode: state.questionMode!,
                      mockType: MockType.recommendedMocks))
              .go(context);
        }
      },
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => LearningQuizModeDialog(
              examId: examId,
              questionNumber: numberOfQuestions,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: 7.h,
                height: 7.h,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image(
                  image: AssetImage(image),
                  height: 5.h,
                  width: 5.h,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                examYear,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF868181),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subject,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.book_outlined,
                    size: 18,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    AppLocalizations.of(context)!.national_exam,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF888C8C),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
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
