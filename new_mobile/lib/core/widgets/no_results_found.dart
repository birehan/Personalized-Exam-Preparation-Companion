import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoResultsFound extends StatelessWidget {
  const NoResultsFound({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.article,
          size: 32,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
