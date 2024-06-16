import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextButtons extends StatelessWidget {
  const CustomTextButtons(
      {super.key,
      required this.context,
      required this.icon,
      required this.source,
      required this.text,
      required this.upload});
  final ImageSource source;
  final IconData icon;
  final String text;
  final BuildContext context;
  final Function(ImageSource) upload;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          upload(source);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(
                icon,
                size: Adaptive.h(2),
                color: Colors.black,
              ),
              SizedBox(
                width: Adaptive.w(4),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: Adaptive.h(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ));
  }
}
