import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/constants/app_images.dart';
import 'package:skill_bridge_mobile/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';

class SignInWithGoogleWidget extends StatelessWidget {
  const SignInWithGoogleWidget({
    required this.text,
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthenticationBloc>().add(SignInWithGoogleEvent());
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xff18786a).withOpacity(.3),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(
              googleIcon,
              height: 20,
              width: 20,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
