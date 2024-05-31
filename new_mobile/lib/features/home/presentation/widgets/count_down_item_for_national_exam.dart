import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CounrDownItemCard extends StatelessWidget {
  const CounrDownItemCard({
    super.key,
    required this.countDown,
    required this.label,
  });

  final String countDown;
  final String label;

  @override
  Widget build(BuildContext context) {
    final countDownList = countDown.split('');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: List.generate(
            countDownList.length,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 5.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff3a7dbb),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    // child: Center(
                    //   child: Text(
                    //     countDownList[index],
                    //     style: GoogleFonts.poppins(
                    //       color: Colors.white,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                  ),
                  Container(
                    width: 5.w,
                    height: 2,
                    color: const Color(0xff306496),
                  ),
                  Text(
                    countDownList[index],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 10,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}
