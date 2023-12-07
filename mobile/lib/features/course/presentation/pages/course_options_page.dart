import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';

import '../../../features.dart';
import '../bloc/course/course_bloc.dart';

class CourseOptionsPage extends StatefulWidget {
  const CourseOptionsPage({super.key, required this.course});

  final Course course;

  @override
  State<CourseOptionsPage> createState() => _CourseOptionsPageState();
}

class _CourseOptionsPageState extends State<CourseOptionsPage> {
  String courseid = '';
  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  Scaffold buildWidget(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            color: const Color(0xff18786A),
          ),
          Positioned(
              top: 10.h,
              left: 5.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello there,',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'How do you want to',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'prepare for the exam?',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )),
          Positioned(
            top: 33.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(5.h),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<CourseWithUserAnalysisBloc>()
                                    .add(GetCourseByIdEvent(id: courseid));
                                context.push(AppRoutes.courseDetail);
                              },
                              child: const ChoosePreparingMethod(
                                imageName: 'assets/images/teaching.jpg',
                                title: 'Learning Path',
                                routeName: AppRoutes.courseDetail,
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                context.push(AppRoutes.quizListPage,
                                    extra: widget.course);
                              },
                              child: const ChoosePreparingMethod(
                                imageName: 'assets/images/test_passed.jpg',
                                title: 'Questions Hub',
                                routeName: AppRoutes.questionPage,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 4.h),
                  BlocBuilder<CourseBloc, CourseState>(
                    builder: (context, state) {
                      if (state is CourseErrorState) {
                        return const Center(
                          child: Text('There is error while loading courses'),
                        );
                      } else if (state is CoursePopulatedState) {
                        Course course = state.course;
                        courseid = course.id;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            SizedBox(
                              height: 15.h,
                              child: SingleChildScrollView(
                                child: Text(
                                  course.description,
                                  maxLines: 6,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    wordSpacing: 5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.book_outlined,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  '${course.numberOfChapters} Chapters',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      }
                      return const CustomProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 2.h,
            left: 3.w,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_backspace_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
