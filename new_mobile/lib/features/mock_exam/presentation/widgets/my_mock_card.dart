import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MyMockCard extends StatelessWidget {
  const MyMockCard({
    super.key,
    required this.isCompleted,
    required this.examName,
    required this.numberOfQuestions,
    required this.timeLeft,
    required this.examId,
    required this.isMock,
    required this.progress,
    this.isDownloadedMocks = false,
    this.downloadedUserMock,
  });

  final bool isCompleted;
  final String examId;
  final String examName;
  final String timeLeft;
  final int numberOfQuestions;
  final bool isMock;
  final double progress;
  final bool isDownloadedMocks;
  final DownloadedUserMock? downloadedUserMock;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
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
                  const SizedBox(height: 12),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '$numberOfQuestions QUESTIONS',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8A8888),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
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
              InkWell(
                onTap: () {
                  if (isDownloadedMocks) {
                    if (isCompleted) {
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => LearningQuizModeDialog(
                        examId: examId,
                        questionNumber: numberOfQuestions,
                        downloadedUserMock: downloadedUserMock,
                      ),
                    );
                  } else {
                    MyExamsMockDetailPageRoute(mockId: examId).go(context);
                  }
                },
                child: Container(
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
                        isCompleted ? 'RETAKE' : 'RESUME',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0072FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
