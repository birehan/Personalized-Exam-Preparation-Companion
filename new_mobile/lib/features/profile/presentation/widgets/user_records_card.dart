import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingleRecordCard extends StatelessWidget {
  const SingleRecordCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.number,
  });
  final String imagePath;
  final String text;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 4.h, // Set the width of the image
          height: 4.h, // Set the height of the image
          fit: BoxFit.cover, // You can adjust the BoxFit as needed
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number.toString(),
                style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: .25.h),
              Text(
                text,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        )
      ],
    );
  }
}
