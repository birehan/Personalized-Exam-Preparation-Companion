import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    super.key,
    required this.indicators,
    required this.title,
    required this.description,
    required this.index,
    required this.onNext,
  });

  final int index;
  final Widget indicators;
  final String title;
  final String description;
  final Function(int) onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: index == 2 ? 8.h : 0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: title,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 85.w,
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: description,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 18,
                    width: 60,
                    child: indicators,
                  ),
                  SizedBox(
                    height: index == 2 ? 0.h : 6.h,
                  ),
                  SizedBox(
                    height: index == 2 ? 60.h : 50.h,
                    child: Image.asset(
                      'assets/images/onboarding_${index + 1}.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
