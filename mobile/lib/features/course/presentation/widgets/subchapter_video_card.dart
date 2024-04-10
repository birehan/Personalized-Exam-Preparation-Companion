import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../features.dart';

class SubChapterVideoCard extends StatelessWidget {
  const SubChapterVideoCard({
    super.key,
    required this.subchapterVideo,
    required this.courseId,
  });

  final SubchapterVideo subchapterVideo;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        VideoPlayerPageRoute(
          courseId: courseId,
          videoLink: subchapterVideo.videoLink,
          lastStartedSubChapterId: null,
        ).go(context);
      },
      child: SizedBox(
        width: 100.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  subchapterVideo.thumbnailUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60.w,
                  child: Text(
                    subchapterVideo.title,
                    // 'Determinants of Matrices of Order 3',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  subchapterVideo.duration,
                  // '10 mins',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
