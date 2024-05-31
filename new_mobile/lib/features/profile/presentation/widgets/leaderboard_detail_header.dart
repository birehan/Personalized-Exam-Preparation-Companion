import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:skill_bridge_mobile/core/constants/app_images.dart';

import 'package:skill_bridge_mobile/core/core.dart';

import 'package:skill_bridge_mobile/features/profile/presentation/bloc/logout/logout_bloc.dart';

import '../../../../core/utils/snack_bar.dart';

class LeaderbordDetailHeader extends StatelessWidget {
  final int? grade;
  final String firstName;
  final String lastName;
  final String avatar;

  const LeaderbordDetailHeader({
    super.key,
    this.grade,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogOutFailedState &&
            state.failure is RequestOverloadFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar(state.failure.errorMessage));
        }
        if (state is LogedOutState) {
          LoginPageRoute().go(context);
        }
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 110,
            width: 110,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(avatar),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                // SizedBox(height: .5.h),
                if (grade != null)
                  Text(
                    'Grade $grade',
                    style: const TextStyle(
                        color: Color(0xff18786a),
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
