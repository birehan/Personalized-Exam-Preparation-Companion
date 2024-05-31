import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/question/presentation/bloc/endOfChaptersQuestionsBloc/endof_chapter_questions_bloc.dart';

import '../../../../core/routes/go_routes.dart';
import '../../../chapter/presentation/bloc/subChapterBloc/sub_chapter_bloc.dart';

class SubChapterCardNew extends StatelessWidget {
  const SubChapterCardNew(
      {super.key,
      required this.sampleImage,
      required this.content,
      required this.subChapterOrChapterId,
      required this.courseId,
      required this.text,
      required this.completed});

  final String sampleImage;
  final String subChapterOrChapterId;
  final bool content;
  final String courseId;
  final String text;
  final bool completed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  if (content) {
                    // context.read<SubChapterBloc>().add(
                    //       GetSubChapterContentsEvent(
                    //           subChapterId: subChapterOrChapterId),
                    //     );
                    ContentPageRoute(
                            courseId: courseId,
                            readOnly: false,
                            subChapterId: subChapterOrChapterId)
                        .go(context);
                  } else {
                    context.read<EndofChapterQuestionsBloc>().add(
                        EndOfChapterFetchedEvent(
                            chapterId: subChapterOrChapterId));
                    EndOfChapterQuestionsPageRoute(courseId: courseId)
                        .go(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(.5.h),
                  height: 10.h,
                  width: 10.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: completed
                            ? const Color(0xff18786a)
                            : const Color(0xffDCE8F7),
                        width: .4.h),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: Container(
                      height: 6.h,
                      width: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.h),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              // sampleImages[math.Random().nextInt(2)]
                              sampleImage),
                        ),
                      )),
                ),
              ),
              SizedBox(height: 1.h),
              if (content)
                Container(
                  height: 4.h,
                  width: 1.5.w,
                  decoration: BoxDecoration(
                      color: completed
                          ? const Color(0xff18786a)
                          : const Color(0xffDCE8F7),
                      borderRadius: BorderRadius.circular(10)),
                ),
              SizedBox(height: 1.h),
            ],
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (content) {
                  // context.read<SubChapterBloc>().add(
                  //       GetSubChapterContentsEvent(
                  //           subChapterId: subChapterOrChapterId),
                  //     );
                  ContentPageRoute(
                          courseId: courseId,
                          readOnly: false,
                          subChapterId: subChapterOrChapterId)
                      .go(context);
                } else {
                  context.read<EndofChapterQuestionsBloc>().add(
                      EndOfChapterFetchedEvent(
                          chapterId: subChapterOrChapterId));
                  EndOfChapterQuestionsPageRoute(courseId: courseId)
                      .go(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 2.h, left: 4.w),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (content) {
                // context.read<SubChapterBloc>().add(
                //       GetSubChapterContentsEvent(
                //           subChapterId: subChapterOrChapterId),
                //     );
                ContentPageRoute(
                        courseId: courseId,
                        readOnly: false,
                        subChapterId: subChapterOrChapterId)
                    .go(context);
              } else {
                context.read<EndofChapterQuestionsBloc>().add(
                    EndOfChapterFetchedEvent(chapterId: subChapterOrChapterId));
                EndOfChapterQuestionsPageRoute(courseId: courseId).go(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(top: 2.h, left: 2.w),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A7A6C),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed ? Icons.check : Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
