import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_user_records.dart';

class OverviewWidget extends StatelessWidget {
  final int chapterNum;
  final int topicsNum;
  // final double points;
  final int questionsNum;
  const OverviewWidget({
    super.key,
    required this.chapterNum,
    required this.topicsNum,
    // required this.points,
    required this.questionsNum,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UpdatedSingleRecordCard(
                    imageColor: const Color(0xffa4a5e2),
                    imagePath: 'assets/images/Book.png',
                    number: chapterNum.toDouble(),
                    text: 'Chapters Completed'),
              ),
              SizedBox(width: 2.w),
              SizedBox(
                width: 40.w,
                child: UpdatedSingleRecordCard(
                    imageColor: const Color(0xff84abf4),
                    imagePath: 'assets/images/askQuestion.png',
                    number: questionsNum.toDouble(),
                    text: 'Questions Solved'),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UpdatedSingleRecordCard(
                    imageColor: const Color(0xffb9b9b9),
                    imagePath: 'assets/images/Overview.png',
                    number: topicsNum.toDouble(),
                    text: 'Topics Completed'),
              ),
              SizedBox(width: 2.w),
            ],
          ),
        ),
      ],
    );
  }
}
