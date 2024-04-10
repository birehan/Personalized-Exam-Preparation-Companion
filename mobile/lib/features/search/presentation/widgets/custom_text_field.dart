import 'package:flutter/material.dart';

class CustomSearchTextField extends StatelessWidget {
  final String hintText;
  final IconData? leadingIcon;
  final TextEditingController controller;
  final bool? autoFocus;
  final void Function(String)? onSearchFieldChanged;

  const CustomSearchTextField({
    super.key,
    required this.hintText,
    this.leadingIcon,
    required this.controller,
    this.autoFocus,
    this.onSearchFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        autofocus: autoFocus == true ? true : false,
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          letterSpacing: 2,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10),
          icon: leadingIcon != null ? Icon(leadingIcon) : null,
          fillColor: const Color(0xffF6F7Fc),
          focusColor: const Color(0xff18786A),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xff18786A),
              )),
          filled: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
        ),
        onSubmitted: (value) {
          //! implement on submit
        },
        onChanged: (v) => onSearchFieldChanged!(v));
  }
}
