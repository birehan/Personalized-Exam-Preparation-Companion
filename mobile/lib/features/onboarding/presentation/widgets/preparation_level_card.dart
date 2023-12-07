import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingCard extends StatelessWidget {
  final bool selected;
  final String text;
  final String imageAdress;
  final Function() onTap;
  const OnboardingCard({
    super.key,
    required this.selected,
    required this.text,
    required this.imageAdress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 6.w, right: 3.w, top: 3.h, bottom: 3.h),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              width: 0.1,
              color: selected
                  ? const Color(0xff18786A)
                  : const Color.fromARGB(255, 223, 218, 218)),
          color:
              selected ? const Color(0xff18786A).withOpacity(.1) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage(imageAdress),
                  height: 3.h,
                  width: 3.h,
                ),
                SizedBox(width: 3.w),
                SizedBox(
                  width: 55.w,
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Checkbox(
              value: selected,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onChanged: (val) {},
              fillColor: selected
                  ? MaterialStateProperty.all<Color>(const Color(0xff18786A))
                  : MaterialStateProperty.all<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
