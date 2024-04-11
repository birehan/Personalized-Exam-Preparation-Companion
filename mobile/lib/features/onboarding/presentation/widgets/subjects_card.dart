import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubjectsCard extends StatelessWidget {
  final bool selected;
  final Function() onTap;
  final String image;
  final String title;
  const SubjectsCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.all(1.h),
            padding: EdgeInsets.all(1.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected
                  ? const Color(0xff18786A).withOpacity(.16)
                  : const Color.fromARGB(181, 206, 206, 201).withOpacity(.16),
              border: Border.all(
                  color:
                      selected ? const Color(0xff18786A) : Colors.transparent,
                  width: 3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    height: 12.5.h,
                    width: 12.5.h,
                    fit: BoxFit.cover,
                    image: AssetImage(image),
                  ),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
        if (selected)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(.5.h),
              height: 4.h,
              width: 4.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.h),
                  color: const Color(0xff18786A),
                  border: Border.all(color: Colors.white, width: 3)),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
      ],
    );
  }
}
