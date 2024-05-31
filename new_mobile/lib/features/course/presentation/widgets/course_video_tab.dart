import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class CourseVideoTab extends StatefulWidget {
  const CourseVideoTab({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<CourseVideoTab> createState() => _CourseVideoTabState();
}

class _CourseVideoTabState extends State<CourseVideoTab> {
  @override
  void initState() {
    super.initState();
    context
        .read<FetchCourseVideosBloc>()
        .add(FetchSingleCourseVideosEvent(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocListener<FetchCourseVideosBloc, FetchCourseVideosState>(
          listener: (context, state) {
            if (state is FetchCourseVideosFailed &&
                state.failure is RequestOverloadFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(state.failure.errorMessage));
            }
          },
          child: BlocBuilder<FetchCourseVideosBloc, FetchCourseVideosState>(
            builder: (context, state) {
              if (state is FetchCourseVideosLoading) {
                return _courseVideoTabShimmer();
              } else if (state is FetchCourseVideosLoaded) {
                state.chapterVideos.sort(
                  (a, b) => a.order.compareTo(b.order),
                );

                return Column(
                  children: List.generate(
                    state.chapterVideos.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ChapterVideoWidget(
                        chapterVideo: state.chapterVideos[index],
                        courseId: widget.courseId,
                        chapterIndex: index,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(),
                    // child: ChapterVideoWidget(chapterVideo: ,),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Shimmer _courseVideoTabShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Column(
              children: List.generate(
                4,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20.w,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 45.w,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 24.w,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 45.w,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 16.w,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
