import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaderboardProfileStatCard extends StatelessWidget {
  final String title;
  final String number;
  final bool isForPoint;
  final double width;
  const LeaderboardProfileStatCard({
    super.key,
    required this.title,
    required this.number,
    required this.isForPoint,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 243, 243, 243),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isForPoint)
            Image.asset(
              'assets/images/leftFlower.png',
              fit: BoxFit.cover,
              height: 5.h,
              width: 4.w,
            ),
          Column(
            children: [
              Text(
                number,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45),
              )
            ],
          ),
          if (isForPoint)
            Image.asset(
              height: 5.h,
              width: 4.w,
              'assets/images/rightFlower.png',
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
