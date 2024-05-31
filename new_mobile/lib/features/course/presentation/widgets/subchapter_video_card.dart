import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/course/presentation/bloc/changeVideoStatus/change_video_status_bloc.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../features.dart';

class SubChapterVideoCard extends StatefulWidget {
  const SubChapterVideoCard({
    super.key,
    required this.subchapterVideo,
    required this.courseId,
    required this.selected,
    required this.chapterIndex,
    required this.subChapterIndex,
  });

  final SubchapterVideo subchapterVideo;
  final String courseId;
  final bool selected;
  final int subChapterIndex;
  final int chapterIndex;

  @override
  State<SubChapterVideoCard> createState() => _SubChapterVideoCardState();
}

class _SubChapterVideoCardState extends State<SubChapterVideoCard> {
  late bool isSelected;
  @override
  void initState() {
    super.initState();
    isSelected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangeVideoStatusBloc, ChangeVideoStatusState>(
      listener: (context, state) {
        // if (state is ChangeVideoStatusFailed) {
        //   //revert if not successful
        //   context.read<FetchCourseVideosBloc>().add(ChangeVideoStatusLocally(
        //       chapterIndex: widget.chapterIndex,
        //       subchapterindex: widget.subChapterIndex));
        //   // setState(() {
        //   //   isSelected = !isSelected;
        //   // });
        // }
        //! handle if not successfull. The issue is it is updating all cards if not
      },
      child: InkWell(
        onTap: () {
          VideoPlayerPageRoute(
            courseId: widget.courseId,
            videoLink: widget.subchapterVideo.videoLink,
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
                    widget.subchapterVideo.thumbnailUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          widget.subchapterVideo.title,
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
                        widget.subchapterVideo.duration,
                        // '10 mins',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Checkbox(
                    value: widget.subchapterVideo.isCompleted,
                    onChanged: (value) {
                      // setState(() {
                      //   isSelected = value!;
                      // });
                      context.read<FetchCourseVideosBloc>().add(
                          ChangeVideoStatusLocally(
                              chapterIndex: widget.chapterIndex,
                              subchapterindex: widget.subChapterIndex));
                      context
                          .read<ChangeVideoStatusBloc>()
                          .add(ChangeSingleVideoStatusEvent(
                            videoId: widget.subchapterVideo.id,
                            isCompleted: value!,
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
