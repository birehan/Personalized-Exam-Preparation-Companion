import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features.dart';

class DownloadedCourseDetailTab extends StatelessWidget {
  DownloadedCourseDetailTab({
    super.key,
    required this.course,
  });

  final Course course;

  final _scrollBarController = ScrollController();

  final scrollDirection = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.h, right: 4.w, left: 4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.w,
                  height: 23.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                          course.image.imageAddress,
                        )),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 23.h),
                      child: Scrollbar(
                        controller: _scrollBarController,
                        thumbVisibility: true,
                        thickness: 4,
                        child: SingleChildScrollView(
                          controller: _scrollBarController,
                          child: Text(
                            course.description,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.visible,
                            // maxLines: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.only(bottom: 4.h, right: 4.w, left: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
                      decoration: BoxDecoration(
                        color: Color(course.isNewCurriculum
                                ? 0xff18786a
                                : 0xffFEA800)
                            .withOpacity(.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        course.isNewCurriculum
                            ? AppLocalizations.of(context)!.new_key
                            : AppLocalizations.of(context)!.old,
                        style: TextStyle(
                          color: Color(course.isNewCurriculum
                                  ? 0xff18786a
                                  : 0xffFEA800 //0xffFEA800
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 1.h),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(7),
                //   child: LinearProgressIndicator(
                //     semanticsValue:
                //         '${((widget.completedChapters / widget.allChapters) * 100).round()}%',
                //     value: widget.completedChapters / widget.allChapters,
                //     minHeight: 14,
                //     backgroundColor: const Color(0xffDCE8F7),
                //     valueColor: const AlwaysStoppedAnimation<Color>(
                //       Color(0xff3DB861),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Column(
            children: List.generate(
              course.chapters?.length ?? 0,
              (index) => Padding(
                padding: EdgeInsets.only(right: 4.w, left: 4.w, bottom: 2.h),
                child: DownloadedChapterCard(
                  index: index,
                  course: course,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
