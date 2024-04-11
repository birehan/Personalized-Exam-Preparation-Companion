import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prepgenie/core/core.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../../domain/entities/bookmarked_contents.dart';

class LessonBookmarkCard extends StatelessWidget {
  final BookmarkedContent bookmarkedContent;
  const LessonBookmarkCard({super.key, required this.bookmarkedContent});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.pink,
      Colors.green,
      Colors.orange,
      Colors.blue
    ];
    final random = Random();

    var dateFormat = DateFormat.MMMd().add_y();
    String formattedDate = dateFormat.format(bookmarkedContent.bookmarkedTime);
    return InkWell(
      onTap: () {
        BookmarkedContentPageRoute($extra: bookmarkedContent).go(context);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 2.h, right: 4.w, bottom: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                          color: colors[random.nextInt(4)],
                          borderRadius: BorderRadius.circular(5.w)),
                    ),
                    SizedBox(width: 2.w),
                    Text('Bookmarked Item',
                        style: TextStyle(color: Colors.black.withOpacity(.5))),
                  ],
                ),
                Text(formattedDate,
                    style: TextStyle(color: Colors.black.withOpacity(.5))),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              bookmarkedContent.content.title,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            SizedBox(
              height: 6.h,
              child: MarkdownWidget(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                data: bookmarkedContent.content.content,
                config: MarkdownConfig.defaultConfig,
                markdownGenerator: MarkdownGenerator(
                  generators: [
                    latexGenerator,
                  ],
                  inlineSyntaxList: [LatexSyntax()],
                  richTextBuilder: (span) => Text.rich(span),
                ),
              ),
            ),
            // Text(
            //   bookmarkedContent.content.content,
            //   style:
            //       TextStyle(color: Colors.black.withOpacity(.5), height: 1.5),
            //   maxLines: 3,
            //   overflow: TextOverflow.ellipsis,
            // )
          ],
        ),
      ),
    );
  }
}
