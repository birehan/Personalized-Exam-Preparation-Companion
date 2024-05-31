import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../course/presentation/bloc/course/course_bloc.dart';
import '../../../features.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.userCourse,
  });

  final UserCourse userCourse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CourseBloc>().add(
              SetCourseEvent(course: userCourse.course),
            );
        context.push(AppRoutes.courseOption, extra: userCourse.course);
      },
      child: Container(
        width: 15.h,
        height: 120,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: Text(
                userCourse.course.name,
                // 'Introduction to Programming using python',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.book_outlined,
                  color: Color(0xFF797979),
                  size: 16,
                ),
                Text(
                  '${userCourse.course.numberOfChapters} ${AppLocalizations.of(context)!.chapters}',
                  // '26 chapters',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF797979),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 8,
                  width: 230,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (userCourse.completedChapters /
                          userCourse.course.numberOfChapters),
                      backgroundColor: const Color.fromRGBO(24, 120, 106, 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF18786A),
                      ),
                    ),
                  ),
                ),
                Text(
                  '${((userCourse.completedChapters / userCourse.course.numberOfChapters) * 100).toInt().toStringAsFixed(0)} %',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF363636),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
