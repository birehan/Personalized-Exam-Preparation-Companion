import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkChooseOptionCard extends StatelessWidget {
  const BookmarkChooseOptionCard({
    super.key,
    required this.choice,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isWrongAnswer,
  });

  final String choice;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isWrongAnswer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A7A6C)
              : isWrongAnswer
                  ? Colors.red
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: '$label ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected || isWrongAnswer
                        ? Colors.white
                        : const Color(0xFF333333),
                  ),
                  children: [
                    TextSpan(
                      text: choice,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isSelected || isWrongAnswer
                            ? Colors.white
                            : const Color(0xFF333333),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC9C9C9),
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Color(0xFF1A7A6C),
                      size: 14,
                    )
                  : isWrongAnswer
                      ? const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 14,
                        )
                      : null,
            )
          ],
        ),
      ),
    );
  }
}
