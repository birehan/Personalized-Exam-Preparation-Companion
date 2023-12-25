import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchCourse extends StatelessWidget {
  final VoidCallback? onTap;
  const SearchCourse({
    super.key,
    required TextEditingController searchController,
    this.onTap,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 300,
            color: const Color(0xFFF6F7FC),
            child: TextField(
              enabled: false,
              controller: _searchController,
              cursorColor: const Color(0xFF18786A),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF18786A),
                    width: 2,
                  ),
                ),
                hintText: 'Find Course',
              ),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF363636),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF18786A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.search_rounded,
            color: Colors.white,
            size: 30,
          ),
        )
      ],
    );
  }
}
