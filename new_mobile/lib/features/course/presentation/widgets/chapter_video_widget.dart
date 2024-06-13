import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features.dart';

class ChapterVideoWidget extends StatefulWidget {
  const ChapterVideoWidget({
    super.key,
    required this.chapterVideo,
    required this.courseId,
    required this.chapterIndex,
  });

  final ChapterVideo chapterVideo;
  final String courseId;
  final int chapterIndex;

  @override
  State<ChapterVideoWidget> createState() => _ChapterVideoWidgetState();
}

class _ChapterVideoWidgetState extends State<ChapterVideoWidget> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.chapter} ${widget.chapterVideo.order}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 65.w,
                      child: Text(
                        widget.chapterVideo.title,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      '${widget.chapterVideo.subchapterVideos.length} ${AppLocalizations.of(context)!.videos_available}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                )
              ],
            ),
          ),
          isExpanded && widget.chapterVideo.subchapterVideos.isNotEmpty
              ? const SizedBox(height: 16)
              : Container(),
          if (isExpanded)
            Column(
              children: List.generate(
                widget.chapterVideo.subchapterVideos.length,
                (index) {
                  widget.chapterVideo.subchapterVideos.sort(
                    (a, b) => a.order.compareTo(b.order),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SubChapterVideoCard(
                      subchapterVideo:
                          widget.chapterVideo.subchapterVideos[index],
                      courseId: widget.courseId,
                      selected: widget
                          .chapterVideo.subchapterVideos[index].isCompleted,
                      chapterIndex: widget.chapterIndex,
                      subChapterIndex: index,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
