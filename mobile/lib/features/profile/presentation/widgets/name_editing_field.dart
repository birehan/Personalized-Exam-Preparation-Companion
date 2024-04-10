import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameEditingField extends StatelessWidget {
  const NameEditingField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
  });

  final String title;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: const Color(0xFF363636),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: -0.02,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 13,
        ),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xFFC4C4C4), width: 1), // Border color
                borderRadius: BorderRadius.circular(8), // Border radius
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 87, 87, 87),
                    width: 1), // Border color
                borderRadius: BorderRadius.circular(8), // Border radius
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFA3A3A3),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: -0.02, // Change hint text style
              ),
            ),
            onChanged: (value) {
              // firstname = value;
            },
          ),
        ),
      ],
    );
  }
}
