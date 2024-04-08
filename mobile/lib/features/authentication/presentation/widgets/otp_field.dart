import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPFieldWidget extends StatefulWidget {
  const OTPFieldWidget({
    super.key,
    required this.controller,
    required this.index,
  });

  final TextEditingController controller;
  final int index;

  @override
  State<OTPFieldWidget> createState() => _OTPFieldWidgetState();
}

class _OTPFieldWidgetState extends State<OTPFieldWidget> {
  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;

    void updateColor() {
      setState(() {
        color = const Color(0xFF18786A);
      });
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: widget.controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF18786A),
        ),
        decoration: InputDecoration(
          counterText: '',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: color,
              width: 3,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF18786A),
              width: 3,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && widget.index < 6) {
            FocusScope.of(context).nextFocus();
            updateColor();
          }
          if (value.isEmpty && widget.index > 1) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
