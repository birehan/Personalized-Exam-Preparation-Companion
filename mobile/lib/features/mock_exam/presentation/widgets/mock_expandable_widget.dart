import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';

// import '../bloc/selectCourseBloc/select_course_bloc.dart';
import '../../../../core/widgets/progress_indicator2.dart';
import '../../../features.dart';

class MockExpandableWidget extends StatefulWidget {
  const MockExpandableWidget({
    super.key,
    this.forQuestionGeneration,
    required this.courseName,
    required this.courses,
  });
  final String courseName;
  final List<Course> courses;
  final bool? forQuestionGeneration;

  @override
  State<MockExpandableWidget> createState() => _MockExpandableWidgetState();
}

class _MockExpandableWidgetState extends State<MockExpandableWidget> {
  bool isExpanded = false;
  String courseId = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          iconColor: Colors.black,
          leading: Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            size: 30,
          ),
          trailing: Text(
            '${widget.courses.length}',
            style: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 88, 88, 88)),
          ),
          title: Text(
            widget.courseName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          ListView.builder(
            padding: EdgeInsets.only(left: 3.w),
            shrinkWrap: true,
            itemCount: widget.courses.length,
            itemBuilder: (context, index) {
              return BlocConsumer<ChapterBloc, ChapterState>(
                listener: (context, state) {
                  if (state is GetChapterByCourseIdState &&
                      state.status == ChapterStatus.loaded) {
                    // context.push(
                    //   AppRoutes.quizGeneratorPage,
                    //   extra: QuizGeneratorPageParams(
                    //     courseId,
                    //     state.chapters!,
                    //   ),
                    // );
                  }
                },
                builder: (context, state) {
                  return Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ListTile(
                        trailing:
                            Text('${widget.courses[index].numberOfChapters}'),
                        contentPadding: const EdgeInsets.only(left: 10),
                        horizontalTitleGap: 0,
                        dense: true,
                        leading: const Icon(
                          Icons.lens,
                          size: 10,
                          color: Colors.black45,
                        ),
                        title: Text(
                          widget.courses[index].name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          // ! Navigate to course detail page
                          //! register course
                          if (widget.forQuestionGeneration != null &&
                              widget.forQuestionGeneration!) {
                            setState(() {
                              courseId = widget.courses[index].id;
                            });

                            context.read<ChapterBloc>().add(
                                  GetChapterByCourseIdEvent(
                                    courseId: widget.courses[index].id,
                                  ),
                                );
                            return;
                          }
                          // context.read<CourseWithUserAnalysisBloc>().add(
                          //     GetCourseByIdEvent(id: widget.courses[index].id));
                          // context.read<RegisterCourseBloc>().add(
                          //     RegisterUserToACourse(
                          //         courseId: widget.courses[index].id));
                          // context.push(AppRoutes.courseDetail);

                          CourseDetailPageRoute(
                            courseId: widget.courses[index].id,
                          ).go(context);
                        },
                      ),
                      if (state is GetChapterByCourseIdState &&
                          state.status == ChapterStatus.loading &&
                          courseId == widget.courses[index].id)
                        const CustomLinearProgressIndicator(size: 20)
                    ],
                  );
                },
              );
            },
          ),
        const Divider(
          indent: 10,
          height: 2,
          color: Colors.grey,
        ),
      ],
    );
  }
}
