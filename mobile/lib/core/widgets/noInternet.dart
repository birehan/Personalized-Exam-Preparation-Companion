import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({
    super.key,
    required this.reloadCallback,
  });
  final Function() reloadCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        const Icon(
          Icons.signal_wifi_connected_no_internet_4,
          size: 32,
        ),
        SizedBox(height: 2.h),
        Text(
          'No Internet, Check your connection!',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        InkWell(
          onTap: reloadCallback,
          borderRadius: BorderRadius.circular(2.h),
          splashColor: const Color(0xff18786A).withOpacity(.1),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: .7.h, horizontal: 4.w),
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff18786a),
                ),
                borderRadius: BorderRadius.circular(2.h)),
            child: const Text(
              'retry',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: Color(0xff18786a)),
            ),
          ),
        )
      ],
    );
  }
}
