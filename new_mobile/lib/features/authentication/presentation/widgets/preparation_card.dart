import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PreparationCard extends StatelessWidget {
  final String text;
  final String image;
  const PreparationCard({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color.fromARGB(255, 211, 210, 210),
            style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            height: 20.w,
            width: 20.w,
            image: AssetImage(image),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'),
          )
        ],
      ),
    );
  }
}
