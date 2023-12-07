import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_course.dart';
import '../bloc/course/course_bloc.dart';

class EnrolledCoursesCard extends StatelessWidget {
  final UserCourse userCourse;
  const EnrolledCoursesCard({
    super.key,
    required this.userCourse,
  });

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
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 5,
                color: Colors.black.withOpacity(.04))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userCourse.course.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  fontFamily: 'Poppins'),
              maxLines: 1,
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 18.sp,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  ('${userCourse.course.numberOfChapters} chapters'),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: LinearProgressIndicator(
                      value: userCourse.completedChapters /
                          userCourse.course
                              .numberOfChapters, // userProgress should be a double between 0.0 and 1.0
                      minHeight: 10,
                      backgroundColor: const Color(0xffE7F0EF),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xff18786A),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  '${((userCourse.completedChapters / userCourse.course.numberOfChapters) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
