import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearchWidget extends StatelessWidget {
  const MySearchWidget(
      {super.key,
      required TextEditingController searchController,
      required this.iconData,
      required this.hintText,
      required this.enabled})
      : _searchController = searchController;

  final TextEditingController _searchController;
  final IconData iconData;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            enabled: enabled,
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF3D5CFF).withOpacity(.03),
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
              ),
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A7A6C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 32,
          ),
        )
      ],
    );
  }
}
