// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features.dart';
import 'chapters_card_new.dart';

class CourseDetailTab extends StatefulWidget {
  const CourseDetailTab({
    super.key,
    required this.course,
    required this.completedChapters,
    required this.allChapters,
    required this.userChapterAnalysis,
    this.lastStartedSubChapterId,
  });

  final Course course;
  final int completedChapters;
  final int allChapters;
  final List<UserChapterAnalysis> userChapterAnalysis;
  final String? lastStartedSubChapterId;

  @override
  State<CourseDetailTab> createState() => _CourseDetailTabState();
}

class _CourseDetailTabState extends State<CourseDetailTab> {
  final _scrollBarController = ScrollController();
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      axis: scrollDirection,
    );

    if (widget.lastStartedSubChapterId != null) {
      for (int idx = 0; idx < widget.userChapterAnalysis.length; idx++) {
        if (widget.userChapterAnalysis[idx].chapter.id ==
            widget.lastStartedSubChapterId) {
          _scrollToLastStartedChapter(idx);
        }
      }
    }
  }

  Future _scrollToLastStartedChapter(int index) async {
    await controller.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
    controller.highlight(
      index,
      highlightDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
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
                          widget.course.image.imageAddress,
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
                            widget.course.description,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.progress,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
                      decoration: BoxDecoration(
                        color: Color(widget.course.cariculumIsNew
                                ? 0xFF0072FF
                                : 0xffFEA800)
                            .withOpacity(.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.course.cariculumIsNew
                            ? AppLocalizations.of(context)!.new_key
                            : AppLocalizations.of(context)!.old,
                        style: TextStyle(
                          color: Color(widget.course.cariculumIsNew
                                  ? 0xFF0072FF
                                  : 0xffFEA800 //0xffFEA800
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 1.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: LinearProgressIndicator(
                    semanticsValue:
                        '${((widget.completedChapters / widget.allChapters) * 100).round()}%',
                    value: widget.completedChapters / widget.allChapters,
                    minHeight: 14,
                    backgroundColor: const Color(0xffDCE8F7),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xff3DB861),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: List.generate(
              widget.userChapterAnalysis.length,
              (index) => AutoScrollTag(
                key: ValueKey(index),
                index: index,
                controller: controller,
                highlightColor: const Color(0xFF17686A).withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.only(right: 4.w, left: 4.w, bottom: 2.h),
                  child: ChapterCard(
                    index: index + 1,
                    userChapterAnalysis: widget.userChapterAnalysis[index],
                    course: widget.course,
                    lastStartedSubChapterId: widget.lastStartedSubChapterId,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
