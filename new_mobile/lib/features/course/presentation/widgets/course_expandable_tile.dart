import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';

// import '../bloc/selectCourseBloc/select_course_bloc.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/progress_indicator2.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseExpandableWidget extends StatefulWidget {
  const CourseExpandableWidget({
    super.key,
    this.forQuestionGeneration,
    required this.courseName,
    required this.courseUrl,
    required this.courses,
  });
  final String courseName;
  final String courseUrl;
  final List<Course> courses;
  final bool? forQuestionGeneration;

  @override
  State<CourseExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<CourseExpandableWidget> {
  bool isExpanded = false;
  String courseId = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 12,
          iconColor: Colors.black,
          leading: Image.asset(widget.courseUrl, width: 36, height: 36),
          trailing: Text(
            '${widget.courses.length}',
            style: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 88, 88, 88)),
          ),
          // trailing: SizedBox(
          //   width: 15.w,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text(
          //         '${widget.courses.length}',
          //         style: const TextStyle(
          //             fontSize: 18, color: Color.fromARGB(255, 88, 88, 88)),
          //       ),
          //       const SizedBox(width: 4),
          //       Icon(
          //         isExpanded
          //             ? Icons.keyboard_arrow_down
          //             : Icons.keyboard_arrow_right,
          //         size: 30,
          //       ),
          //     ],
          //   ),
          // ),
          title: Text(
            widget.courseName.toUpperCase(),
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.courses.length,
            itemBuilder: (context, index) {
              List<Course> departmentCourses = widget.courses;
              departmentCourses.sort((a, b) => a.grade.compareTo(b.grade));
              return BlocConsumer<ChapterBloc, ChapterState>(
                listener: (context, state) {
                  if (state is GetChapterByCourseIdState) {
                    if (state.status == ChapterStatus.error &&
                        state.failure is RequestOverloadFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar(state.failure!.errorMessage));
                    } else if (state.status == ChapterStatus.loaded) {
                      // TODO: Take to quizGeneratorPage

                      // context.push(
                      //   AppRoutes.quizGeneratorPage,
                      //   extra: QuizGeneratorPageParams(
                      //     courseId,
                      //     state.chapters!,
                      //   ),
                      // );
                    }
                  }
                },
                builder: (context, state) {
                  return Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ListTile(
                        trailing: Text(
                            '${departmentCourses[index].numberOfChapters}'),
                        contentPadding: const EdgeInsets.only(left: 10),
                        horizontalTitleGap: 0,
                        dense: true,
                        leading: const Icon(
                          Icons.lens,
                          size: 10,
                          color: Colors.black45,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${departmentCourses[index].name} ${AppLocalizations.of(context)!.grade} ${widget.courses[index].grade}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: .5.h),
                              decoration: BoxDecoration(
                                color: Color(
                                        departmentCourses[index].isNewCurriculum
                                            ? 0xff18786a
                                            : 0xffFEA800)
                                    .withOpacity(.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                departmentCourses[index].isNewCurriculum
                                    ? AppLocalizations.of(context)!.new_key
                                    : AppLocalizations.of(context)!.old,
                                style: TextStyle(
                                  color: Color(
                                      departmentCourses[index].isNewCurriculum
                                          ? 0xff18786a
                                          : 0xffFEA800 //0xffFEA800
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
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
        // const SizedBox(height: 4),
        isExpanded
            ? const Divider(
                indent: 10,
                height: 2,
                color: Color(0xFFCFCCCC),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 83.w,
                    child: const Divider(
                      indent: 10,
                      height: 2,
                      color: Color(0xFFCFCCCC),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
