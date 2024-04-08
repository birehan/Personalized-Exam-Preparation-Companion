import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TooltipWidget extends StatelessWidget {
  final String message;
  final double? iconSize;
  const TooltipWidget({
    super.key,
    this.iconSize,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      textStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
      showDuration: const Duration(seconds: 30),
      verticalOffset: 1.5.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff3F4B49).withOpacity(.07),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.black12,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      triggerMode: TooltipTriggerMode.tap,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Icon(
        Icons.info_outline,
        size: iconSize,
      ),
    );
  }
}
