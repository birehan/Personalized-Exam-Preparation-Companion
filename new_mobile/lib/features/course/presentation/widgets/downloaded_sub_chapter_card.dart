import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/routes/go_routes.dart';
import '../../../features.dart';

class DownloadedSubChapterCard extends StatelessWidget {
  const DownloadedSubChapterCard({
    super.key,
    required this.sampleImage,
    required this.course,
    required this.chapterIdx,
    required this.subChapterIdx,
  });

  final String sampleImage;
  final Course course;
  final int chapterIdx;
  final int subChapterIdx;
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
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(.5.h),
                  height: 10.h,
                  width: 10.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffDCE8F7),
                      width: .4.h,
                    ),
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
              Container(
                height: 4.h,
                width: 1.5.w,
                decoration: BoxDecoration(
                    color: const Color(0xffDCE8F7),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(height: 1.h),
            ],
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                DownloadedContentPageRoute(
                  $extra: course,
                  chapterIdx: chapterIdx,
                  subChapterIdx: subChapterIdx,
                ).go(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 2.h, left: 4.w),
                child: Text(
                  course.chapters![chapterIdx].subChapters![subChapterIdx].name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              DownloadedContentPageRoute(
                $extra: course,
                chapterIdx: chapterIdx,
                subChapterIdx: subChapterIdx,
              ).go(context);
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
                child: const Icon(
                  Icons.keyboard_arrow_right_outlined,
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
