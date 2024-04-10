import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../course/presentation/bloc/course/course_bloc.dart';
import '../../../features.dart';

class SearchEnrolledCoursesCard extends StatelessWidget {
  final Course course;
  const SearchEnrolledCoursesCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CourseBloc>().add(SetCourseEvent(course: course));
        context.push(AppRoutes.courseOption, extra: course);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Shadow color
              spreadRadius: 0, // Spread radius
              blurRadius: 2, // Blur radius
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.book_outlined,
                    size: 18,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text('${course.numberOfChapters} chapters')
                ],
              ),
              // SizedBox(
              //   height: 2.h,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(7),
              //         child: const LinearProgressIndicator(
              //           value:
              //               0.3, // userProgress should be a double between 0.0 and 1.0
              //           minHeight: 10,
              //           backgroundColor: Color(0xffE7F0EF),
              //           valueColor: AlwaysStoppedAnimation<Color>(
              //             Color(0xff18786A),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 3.w,
              //     ),
              //     const Text(
              //       '34%',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
