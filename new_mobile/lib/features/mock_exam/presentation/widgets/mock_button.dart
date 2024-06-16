import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MockButton extends StatelessWidget {
  const MockButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.imageUrl,
    this.iconData,
    this.iconColor,
    this.elevation,
  });

  final String buttonText;
  final Function() onPressed;
  final Color bgColor;
  final Color textColor;
  final String? imageUrl;
  final IconData? iconData;
  final Color? iconColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        elevation: elevation,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          iconData == null
              ? Image.asset(imageUrl!, width: 24)
              : Icon(
                  iconData,
                  color: iconColor,
                ),
          const SizedBox(width: 4),
          Text(
            buttonText,
            style: GoogleFonts.poppins(
              // color: Colors.white,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
