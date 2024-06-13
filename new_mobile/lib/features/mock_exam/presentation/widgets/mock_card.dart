import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/features.dart';

import '../../../../core/core.dart';

class MockCard extends StatelessWidget {
  const MockCard({
    super.key,
    required this.courseName,
    required this.isStandard,
    required this.imageUrl,
    required this.timeCountDown,
    required this.examId,
    required this.examTitle,
    required this.numberOfQuestions,
    required this.examYear,
  });

  final String courseName;
  final bool isStandard;
  final String imageUrl;
  final String timeCountDown;
  final String examId;
  final String examTitle;
  final int numberOfQuestions;
  final String examYear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UniversityMockExamDetailPage(
          mockId: examId,
          courseImage: imageUrl,
          courseName: courseName,
          isStandard: isStandard,
        ).go(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF6ECEC)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(.05),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(imageUrl),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFF8A8888),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeCountDown,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF8A8888),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 45.w),
                        child: Text(
                          examTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$numberOfQuestions questions',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF8A8888),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8A8888),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            examYear,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF8A8888),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      UniversityMockExamDetailPage(
                        mockId: examId,
                        courseImage: imageUrl,
                        courseName: courseName,
                        isStandard: isStandard,
                      ).go(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0072FF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 8),
                            blurRadius: 8,
                            color: const Color(0xFF0072FF).withOpacity(.5),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // );
  }
}
