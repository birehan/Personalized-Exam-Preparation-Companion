import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../bloc/registerContest/register_contest_bloc.dart';

class ContestListCard extends StatelessWidget {
  const ContestListCard({
    super.key,
    required this.contest,
  });

  final Contest contest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ContestDetailPageRoute(
          id: contest.id,
        ).go(context);
        // ContestQuestionByCategoryPageRoute(categoryId: '659e5b96f7f62073ac67cf33').go(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        margin: EdgeInsets.symmetric(horizontal: .5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              // spreadRadius: 1,

              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60.w,
                  child: Text(
                    contest.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  DateFormat('MMM dd, yyyy hh:mmaa').format(contest.startsAt),
                  // 'Dec 15, 2023 08:00PM',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black.withOpacity(.6),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                  color: const Color(0xff18786a),
                  borderRadius: BorderRadius.circular(6)),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.start,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
