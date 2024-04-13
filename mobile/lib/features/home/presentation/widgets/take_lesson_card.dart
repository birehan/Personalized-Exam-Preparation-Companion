import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/core.dart';

import '../../../features.dart';

class TakeLessonCard extends StatelessWidget {
  const TakeLessonCard({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is GetHomeState && state.status == HomeStatus.loaded) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(.05),
                )
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF0072FF).withOpacity(.19),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Lesson',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0072FF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                child: Text(
                                  state.lastStartedChapter == null
                                      ? 'Take Your First Lesson'
                                      : 'Continue Studying',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF4C4646),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: Text(
                                  state.lastStartedChapter == null
                                      ? 'Begin your journey!'
                                      : state.lastStartedChapter!.name,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0072FF),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              InkWell(
                                onTap: () {
                                  if (state.lastStartedChapter == null) {
                                    ChooseSubjectPageRoute($extra: false)
                                        .go(context);
                                    // context.push(AppRoutes.chooseSubjectPage,
                                    //     extra: false);
                                  } else {
                                    // ChooseSubjectPageRoute($extra: false)
                                    //     .go(context);
                                    CourseDetailPageRoute(
                                      courseId:
                                          state.lastStartedChapter!.courseId,
                                      lastStartedSubChapterId:
                                          state.lastStartedChapter!.id,
                                    ).go(context);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF0072FF)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Color(0xFF0072FF),
                                        size: 32,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Start',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF0072FF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    TimeCountDownWidget(
                      targetDate: state.examDates!.isEmpty
                          ? DateTime.now()
                          : state.examDates![0].date,
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.8,
                      heightFactor: 0.6,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFA7E8C9),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  right: 0,
                  child: Image.asset(
                    'assets/images/online_lesson.png',
                    fit: BoxFit.cover,
                    width: width * 0.5,
                    height: height * 0.2,
                  ),
                ),
                state.lastStartedChapter == null
                    ? Container()
                    : Positioned(
                        top: 30,
                        right: 8,
                        child: Text(
                          state.lastStartedChapter!.courseName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      )
              ],
            ),
          );
        } else if (state is GetHomeState &&
            state.status == HomeStatus.loading) {
          return _shimmerTakeLessonCard();
        }
        return Container();
      },
    );
  }

  _shimmerTakeLessonCard() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
