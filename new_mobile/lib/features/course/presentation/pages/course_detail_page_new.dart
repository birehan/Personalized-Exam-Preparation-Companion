import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/widgets/noInternet.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseDetailPageNew extends StatefulWidget {
  const CourseDetailPageNew({
    super.key,
    required this.courseId,
    this.lastStartedSubChapterId,
  });

  final String courseId;
  final String? lastStartedSubChapterId;

  @override
  State<CourseDetailPageNew> createState() => _CourseDetailPageNewState();
}

class _CourseDetailPageNewState extends State<CourseDetailPageNew>
    with TickerProviderStateMixin {
  double appBarHeight = 33.h;

  late final TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    context.read<CourseWithUserAnalysisBloc>().add(
          GetCourseByIdEvent(
            id: widget.courseId,
            isRefreshed: false,
          ),
        );
    context.read<RegisterCourseBloc>().add(
          RegisterUserToACourse(
            courseId: widget.courseId,
          ),
        );
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCourseBloc, RegisterCourseState>(
      listener: (context, state) {
        if (state is UserRegisteredState) {
          context.read<UserCoursesBloc>().add(
                const GetUsercoursesEvent(refresh: true),
              );
        }
      },
      child:
          BlocBuilder<CourseWithUserAnalysisBloc, CourseWithUserAnalysisState>(
        builder: (_, state) {
          if (state is CourseErrorState) {
            if (state.failure is NetworkFailure) {
              return Scaffold(
                body: Center(
                  child: NoInternet(
                    reloadCallback: () {
                      context.read<CourseWithUserAnalysisBloc>().add(
                            GetCourseByIdEvent(
                              id: widget.courseId,
                              isRefreshed: true,
                            ),
                          );
                    },
                  ),
                ),
              );
            } else {
              return Scaffold(
                  body: Center(
                      child: Text(AppLocalizations.of(context)!
                          .unkown_error_happened)));
            }
          }
          if (state is CourseLoadingState) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: _courseDetailShimmer(),
            );
          } else if (state is CourseLoadedState) {
            final UserCourseAnalysis userCourseAnalysis =
                state.userCourseAnalysis;
            final Course course = userCourseAnalysis.course;
            final List<UserChapterAnalysis> userChapterAnalysis =
                userCourseAnalysis.userChaptersAnalysis;
            userChapterAnalysis.sort(
              (a, b) => a.chapter.order.compareTo(b.chapter.order),
            );
            int completedChapters = 0;
            int allChapters = 0;
            for (int i = 0; i < userChapterAnalysis.length; i++) {
              completedChapters += userChapterAnalysis[i].completedSubChapters;
              allChapters += userChapterAnalysis[i].subchapters.length;
            }

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    context.pop();
                  },
                ),
                centerTitle: true,
                title: Text(
                  '${course.name} ${AppLocalizations.of(context)!.grade} ${course.grade}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.lessons,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.video,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.quizzes,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  CourseDetailTab(
                    course: course,
                    completedChapters: completedChapters,
                    allChapters: allChapters,
                    userChapterAnalysis: userChapterAnalysis,
                    lastStartedSubChapterId: widget.lastStartedSubChapterId,
                  ),
                  CourseVideoTab(courseId: widget.courseId),
                  MyQuizTab(courseId: course.id),
                ],
              ),
              floatingActionButton: _tabIndex == 2
                  ? FloatingActionButton.extended(
                      backgroundColor: const Color(0xFF17876A),
                      foregroundColor: Colors.white,
                      onPressed: () {
                        CreateQuizPageRoute(courseId: course.id).go(context);
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        AppLocalizations.of(context)!.new_quiz,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : null,
            );
          }
          return Container();
        },
      ),
    );
  }

  Shimmer _courseDetailShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Padding(
        padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4.h,
                width: 35.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  width: 2.w,
                ),
                Expanded(
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  width: 2.w,
                ),
                Expanded(
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 26.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 4.h,
                      width: 45.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      height: 20.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 4.h),
            Container(
              height: 3.h,
              width: 40.w,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(height: 2.h),
            Container(
              height: 2.h,
              width: 90.w,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 2.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 3.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 2.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 10.h,
                  width: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            ListView.separated(
              shrinkWrap: true,
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 10.h,
                      width: 10.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.h)),
                    ),
                    Container(
                      height: 4.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.h)),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
