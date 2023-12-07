import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChoosePreparingMethod extends StatelessWidget {
  final String title;
  final String imageName;
  final String routeName;
  const ChoosePreparingMethod({
    super.key,
    required this.title,
    required this.imageName,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0.5, color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset(imageName),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  color: Color(0xff18786A),
                ),
                height: 30,
                width: 30,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
