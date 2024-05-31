import 'package:flutter/material.dart';

class FlagingChips extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function(bool selected) onSelect;
  const FlagingChips(
      {super.key,
      required this.isSelected,
      required this.title,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FilterChip(
          checkmarkColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          selectedColor: const Color(0xff18786A),
          backgroundColor: const Color(0xffF1F1F1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          label: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black),
          ),
          selected: isSelected,
          onSelected: onSelect),
    );
  }
}
