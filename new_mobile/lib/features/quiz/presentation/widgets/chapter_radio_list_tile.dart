import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features.dart';

class ChapterRadioButton extends StatelessWidget {
  const ChapterRadioButton({
    super.key,
    required this.onTap,
    required this.chapterIndex,
    required this.chapter,
    required this.isSelected,
  });

  final Function() onTap;
  final int chapterIndex;
  final Chapter chapter;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF17876A) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF17876A).withOpacity(0.5)
                      : Colors.grey,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHAPTER ${chapterIndex + 1}',
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    chapter.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
