import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdatedSingleRecordCard extends StatelessWidget {
  const UpdatedSingleRecordCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.number,
    required this.imageColor,
  });
  final String imagePath;
  final String text;
  final double number;
  final Color imageColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                offset: const Offset(0, 1),
                color: Colors.black.withOpacity(.03),
                spreadRadius: 3,
              )
            ],
          ),
          child: Image.asset(
            color: imageColor,
            imagePath,
            width: 25, // Set the width of the image
            height: 25, // Set the height of the image
            fit: BoxFit.cover, // You can adjust the BoxFit as needed
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                maxLines: 2,
                style: const TextStyle(
                    color: Color(0xff8E93A2),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(height: .25.h),
              Text(
                number.ceil().toString(),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
