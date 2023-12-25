import 'package:flutter/material.dart';

class CustomInputFieldProfile extends StatelessWidget {
  final bool enabled;
  final bool visibleBorder;
  final bool filled;
  final String hintText;
  final TextEditingController? controller;
  const CustomInputFieldProfile({
    super.key,
    required this.enabled,
    required this.visibleBorder,
    required this.filled,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: controller,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        letterSpacing: 2,
      ),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        fillColor: const Color.fromARGB(255, 232, 232, 232),
        focusColor: const Color(0xff18786A),
        filled: filled,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 236, 231, 231),
            )),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 15),
      ),
      enabled: enabled,
    );
  }
}
