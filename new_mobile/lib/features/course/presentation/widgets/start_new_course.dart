import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';

class StartNewCourse extends StatelessWidget {
  const StartNewCourse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ChooseSubjectPageRoute($extra: false).go(context);
      },
      child: Container(
        padding: EdgeInsets.all(2.5.h),
        decoration: const BoxDecoration(
          color: Color(0xffE7F0Ef),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  AppLocalizations.of(context)!.start_new_course,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  AppLocalizations.of(context)!.prepare_by_taking_mock_exams,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                color: const Color(0xffFEA800),
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.h,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
