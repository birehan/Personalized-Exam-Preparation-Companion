import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.onTap,
    required this.text,
    // required this.imageUrl,
    required this.isSelected,
  });

  final VoidCallback onTap;
  final String text;
  // final String imageUrl;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        padding: const EdgeInsets.all(12),
        label: Text(text),
        // avatar: Image.asset(imageUrl),
        backgroundColor:
            isSelected ? const Color(0xFF16786A) : Colors.transparent,
        labelStyle: GoogleFonts.poppins(
          color: isSelected ? Colors.white : const Color(0XFF363636),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.white : const Color(0xFFE9E9E9),
          ),
        ),
      ),
    );
  }
}
