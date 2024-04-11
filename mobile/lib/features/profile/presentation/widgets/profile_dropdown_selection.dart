import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileDropdownOptions extends StatefulWidget {
  final List<String> items;
  final double? width;
  final String hintText;
  final String title;
  final String lable;
  final void Function(String?) selectedCallback;
  const ProfileDropdownOptions(
      {Key? key,
      required this.items,
      required this.lable,
      this.width,
      required this.hintText,
      required this.selectedCallback,
      required this.title})
      : super(key: key);

  @override
  _ProfileDropdownOptionsState createState() => _ProfileDropdownOptionsState();
}

class _ProfileDropdownOptionsState extends State<ProfileDropdownOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: const Color(0xFF363636),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: -0.02,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        DropdownMenu(
          controller: TextEditingController(),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: .5.h,
            ),
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
          ),
          // initialSelection: widget.items[1], //change this with correct info
          trailingIcon: const Icon(Icons.keyboard_arrow_down),

          selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
          menuStyle: MenuStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused)) {
                  return Colors.white12;
                }
                return Colors.white;
              },
            ),
          ),
          hintText: widget.hintText,
          textStyle: const TextStyle(
            color: Colors.black54,
          ),

          onSelected: widget.selectedCallback,
          width: widget.width,
          dropdownMenuEntries: widget.items
              .map(
                (item) => DropdownMenuEntry(
                  value: item,
                  label: '${widget.lable} $item',
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
