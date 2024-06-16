import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/course/presentation/widgets/sub_chapter_card_new.dart';
import 'package:prep_genie/features/question/question.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChapterCard extends StatefulWidget {
  final UserChapterAnalysis userChapterAnalysis;
  final Course course;
  final int index;
  final String? lastStartedSubChapterId;

  const ChapterCard({
    super.key,
    required this.userChapterAnalysis,
    required this.course,
    required this.index,
    this.lastStartedSubChapterId,
  });

  @override
  State<ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  bool _customIcon = false;

  @override
  Widget build(BuildContext context) {
    const sampleImages = [
      'assets/images/p1.png',
      'assets/images/p2.png',
      'assets/images/p3.png'
    ];

    int chapterCompletionPercentage;
    try {
      chapterCompletionPercentage =
          (widget.userChapterAnalysis.completedSubChapters /
                  widget.userChapterAnalysis.chapter.noOfSubchapters *
                  100)
              .toInt();
    } catch (e) {
      chapterCompletionPercentage = 0;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .chapter_name(widget.index),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          widget.userChapterAnalysis.chapter.name,
                          maxLines: 3,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          AppLocalizations.of(context)!.subtiopic_completed(
                              widget.userChapterAnalysis.completedSubChapters),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      FillingBar(
                        progress: chapterCompletionPercentage * 1.0,
                        width: 6.h,
                        strokeWidth: 6,
                        height: 6.h,
                      ),
                      Text('$chapterCompletionPercentage %')
                    ],
                  )
                ],
              ),
              trailing: Icon(
                _customIcon
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_circle_rounded,
              ),
              children: [
                SizedBox(height: 2.h),
                ListView.builder(
                  // controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.userChapterAnalysis.subchapters.length,
                  itemBuilder: (context, idx) {
                    return SubChapterCardNew(
                      sampleImage: sampleImages[idx % 2],
                      subChapterOrChapterId:
                          widget.userChapterAnalysis.subchapters[idx].id,
                      content: true,
                      text: widget
                          .userChapterAnalysis.subchapters[idx].subChapterName,
                      courseId: widget.course.id,
                      completed: widget
                          .userChapterAnalysis.subchapters[idx].isCompleted,
                    );
                  },
                ),
                SubChapterCardNew(
                  completed: false,
                  sampleImage: 'assets/images/end_of_chapter_image.png',
                  content: false,
                  subChapterOrChapterId: widget.userChapterAnalysis.chapter.id,
                  courseId: widget.course.id,
                  text: AppLocalizations.of(context)!.national_exam_questions,
                )
              ],
              onExpansionChanged: (bool expanded) {
                setState(() => _customIcon = expanded);
              },
            ),
          ),
        ],
      ),
    );
  }
}
