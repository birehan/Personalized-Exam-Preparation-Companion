import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
             Text(
              AppLocalizations.of(context)!.lesson_completed,
              style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff18786A)),
            ),
            SizedBox(height: 10.h),
            Image(
              image: const AssetImage('assets/images/courseFinal.png'),
              height: 50.w,
              width: 50.w,
            ),
            SizedBox(height: 10.h),
             Text(
              AppLocalizations.of(context)!.congratulations,
              style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 60.w,
              child: Text(
                AppLocalizations.of(context)!.you_have_just_completed_your_first_lesson,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontFamily: 'Poppins', color: Colors.black54),
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                //! register subchapter and go to course detail page
                context.read<UserCoursesBloc>().add(
                      const GetUsercoursesEvent(refresh: true),
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
                  color: const Color(0xff18786A),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.continue_key,
                  style: const TextStyle(
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
