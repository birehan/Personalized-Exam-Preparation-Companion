import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailDisplayWidget extends StatelessWidget {
  const EmailDisplayWidget({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return Text(
      email,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF363636),
      ),
    );
  }
}
