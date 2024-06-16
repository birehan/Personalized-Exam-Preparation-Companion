import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownloadedChapterCard extends StatefulWidget {
  const DownloadedChapterCard({
    super.key,
    required this.course,
    required this.index,
  });

  final Course course;
  final int index;

  @override
  State<DownloadedChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<DownloadedChapterCard> {
  bool _customIcon = false;
  final sampleImages = [
    'assets/images/p1.png',
    'assets/images/p2.png',
    'assets/images/p3.png'
  ];

  @override
  Widget build(BuildContext context) {
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
                              .chapter_name(widget.index + 1),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          widget.course.chapters![widget.index].name,
                          maxLines: 3,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  itemCount: widget
                          .course.chapters![widget.index].subChapters?.length ??
                      0,
                  itemBuilder: (context, idx) {
                    return DownloadedSubChapterCard(
                      sampleImage: sampleImages[idx % 2],
                      course: widget.course,
                      chapterIdx: widget.index,
                      subChapterIdx: idx,
                    );
                  },
                ),
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
