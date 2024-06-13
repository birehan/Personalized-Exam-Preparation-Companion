import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DropDownWithUserInput extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final String title;
  final String lable;
  final void Function(String?) selectedCallback;
  const DropDownWithUserInput({
    Key? key,
    required this.items,
    required this.lable,
    required this.hintText,
    required this.selectedCallback,
    required this.title,
  }) : super(key: key);

  @override
  _DropDownWithUserInputState createState() => _DropDownWithUserInputState();
}

class _DropDownWithUserInputState extends State<DropDownWithUserInput> {
  TextEditingController textController = TextEditingController();
  bool showOptions = false;

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
        TextField(
          controller: textController,
          decoration: InputDecoration(
            suffixIcon: showOptions
                ? const Icon(Icons.keyboard_arrow_up)
                : const Icon(Icons.keyboard_arrow_down),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: .5.h,
            ),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFC4C4C4),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 87, 87, 87),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: widget.hintText,
          ),
          onChanged: (val) {
            widget.selectedCallback(val);
            setState(() {
              if (textController.text.isEmpty) {
                showOptions = false;
              } else {
                showOptions = true;
              }
            });
          },
        ),
        SizedBox(height: 1.h),
        if (showOptions)
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              if (item
                  .toLowerCase()
                  .contains(textController.text.toLowerCase())) {
                return ListTile(
                  title: Text('$item ${widget.lable}'),
                  onTap: () {
                    widget.selectedCallback(item);
                    textController.text = item;
                    setState(() {
                      showOptions = false;
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
