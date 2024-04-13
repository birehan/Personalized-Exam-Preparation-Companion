import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../bloc/userCoursesBloc/user_courses_bloc.dart';

class ContentFinalPage extends StatelessWidget {
  const ContentFinalPage({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Lesson Completed',
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0072FF)),
            ),
            SizedBox(height: 10.h),
            Image(
              image: const AssetImage('assets/images/courseFinal.png'),
              height: 50.w,
              width: 50.w,
            ),
            SizedBox(height: 10.h),
            const Text(
              'Congratulations!',
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 60.w,
              child: const Text(
                'You have just completed your first lesson',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, fontFamily: 'Poppins', color: Colors.black54),
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                //! register subchapter and go to course detail page
                context.read<UserCoursesBloc>().add(
                      GetUsercoursesEvent(refresh: true),
                    );

                // for (int index = 0; index < 2; index++) {
                //   context.pop();
                // }
                context.pop();
              },
              child: Container(
                alignment: Alignment.center,
                height: 8.h,
                width: 45.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF0072FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
