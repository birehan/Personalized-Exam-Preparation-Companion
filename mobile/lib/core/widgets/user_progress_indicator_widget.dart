import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/features.dart';

class UserScoreIndicatorWidget extends StatelessWidget {
  const UserScoreIndicatorWidget({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FillingBar(
          progress: progress,
          width: 64,
          height: 64,
          strokeWidth: 6,
        ),
        Positioned(
          top: 36,
          left: 36,
          child: RichText(
            text: TextSpan(
              text: '${progress.toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3A3A3A),
              ),
            ),
          ),
          // child: Text(
          //   '${progress.toInt()}%',
          //   style: GoogleFonts.poppins(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w600,
          //     color: const Color(0xFF3A3A3A),
          //   ),
          // ),
        ),
      ],
    );
  }
}
