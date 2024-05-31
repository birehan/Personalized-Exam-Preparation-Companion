import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/bookmarked_questions.dart';

class QuestionBookmarkCard extends StatelessWidget {
  final BookmarkedQuestions bookmarkedQeustions;
  const QuestionBookmarkCard({super.key, required this.bookmarkedQeustions});

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
    String formattedDate =
        dateFormat.format(bookmarkedQeustions.bookmarkedTime);
    return Padding(
      padding: EdgeInsets.only(top: 2.h, right: 4.w, bottom: 2.h),
      child: InkWell(
        onTap: () {
          BookmarkedQuestionPageRoute($extra: bookmarkedQeustions).go(context);
        },
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
                    SizedBox(width: 5.w),
                    Text(AppLocalizations.of(context)!.bookmarked_item,
                        style: TextStyle(color: Colors.black.withOpacity(.5))),
                  ],
                ),
                Text(formattedDate,
                    style: TextStyle(color: Colors.black.withOpacity(.5))),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              bookmarkedQeustions.question.description,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
