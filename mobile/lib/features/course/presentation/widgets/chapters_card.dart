import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../features.dart';

class ChaptersCard extends StatelessWidget {
  final UserChapterAnalysis userChapterAnalysis;
  const ChaptersCard({
    super.key,
    required this.userChapterAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<ChapterBloc>()
            .add(GetSubChaptersEvent(id: userChapterAnalysis.chapter.id));
        context.push(AppRoutes.learingPathPage, extra: userChapterAnalysis);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Shadow color
              spreadRadius: 0, // Spread radius
              blurRadius: 2, // Blur radius
              offset: const Offset(0, 2), // Offset in x and y directions
            ),
          ],
        ),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60.w,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          userChapterAnalysis.chapter.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      const Icon(
                        Icons.menu_book_outlined,
                        color: Color(0xff18786A),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: const Color(0xff18786A),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 15,
                  ),
                )
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${userChapterAnalysis.completedSubChapters}/${userChapterAnalysis.chapter.noOfSubchapters}',
                ),
                Text(
                  '${(userChapterAnalysis.completedSubChapters / userChapterAnalysis.chapter.noOfSubchapters * 100).toStringAsFixed(0)}%',
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: LinearProgressIndicator(
                value: userChapterAnalysis.completedSubChapters /
                    userChapterAnalysis.chapter.noOfSubchapters,
                // userProgress should be a double between 0.0 and 1.0
                minHeight: 10,
                backgroundColor: const Color(0xffE7F0EF),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xff18786A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
