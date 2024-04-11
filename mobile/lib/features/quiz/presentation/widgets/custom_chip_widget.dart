import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomChipWidget extends StatelessWidget {
  const CustomChipWidget({
    super.key,
    required this.status,
  });

  final bool status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status
            ? const Color.fromRGBO(103, 209, 129, 0.23)
            : const Color.fromRGBO(255, 193, 7, 0.13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: Text(
          status ? 'Completed' : 'Incomplete',
          style: GoogleFonts.poppins(
            color: status ? const Color(0xFF67D181) : const Color(0xFFFFC107),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
