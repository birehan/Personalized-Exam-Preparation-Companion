import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.label,
    this.prefix,
    this.suffix,
  });

  final TextEditingController controller;
  final String? label;
  final IconButton? prefix;
  final IconButton? suffix;
  final Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => validator(value),
      decoration: InputDecoration(
        hintText: label,
        border: const OutlineInputBorder(),
        prefix: prefix,
        suffix: suffix,
      ),
    );
  }
}
