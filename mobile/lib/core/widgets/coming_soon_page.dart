import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                fit: BoxFit.fitHeight,
                'https://res.cloudinary.com/djrfgfo08/image/upload/v1706105090/SkillBridge/mobile_team_icons/qrenat2c1gmhjbgprdie.png',
                height: 400,
                width: 350,
              ),
              Text(
                'Exciting news – weekly contests are dropping soon! Ace your exams, own your studies, and win cool prizes. App upgrade is in the works – stay tuned!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 18,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
