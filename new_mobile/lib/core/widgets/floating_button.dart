import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 7.h,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0072FF),
            Color.fromARGB(255, 34, 170, 175),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        // color: const Color(0xFF0072FF),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          topLeft: Radius.circular(30),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 7.h,
            width: 7.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.dstATop,
                ),
                image: AssetImage(
                  'assets/images/chatbotImage.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          const Text(
            'Ask',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
