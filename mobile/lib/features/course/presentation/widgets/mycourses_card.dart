import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/go_routes.dart';
import '../../domain/entities/user_course.dart';

class MyCoursesCard extends StatelessWidget {
  const MyCoursesCard({
    super.key,
    required this.userCourse,
  });

  final UserCourse userCourse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CourseDetailPageRoute(courseId: userCourse.course.id).go(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: CachedNetworkImageProvider(
                        userCourse.course.image.imageAddress)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${userCourse.course.name} grade ${userCourse.course.grade}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.book_outlined,
                        color: Color(0xFF797979),
                        size: 18,
                      ),
                      Text(
                        '${userCourse.course.numberOfChapters} chapters',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (userCourse.completedChapters /
                                  userCourse.course.numberOfChapters),
                              backgroundColor:
                                  const Color.fromRGBO(24, 120, 106, 0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF18786A),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
            )
          ],
        ),
      ),
    );
  }
}
