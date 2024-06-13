import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/profile/presentation/widgets/referral_button.dart';

class FriendsAndInviteCard extends StatelessWidget {
  const FriendsAndInviteCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // FriendsMainPageRoute().go(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ComingSoonPage(
                            message:
                                'Exciting new friends feature coming soon! 🎉',
                          )),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/user.png'),
                      ),
                    ),
                  ),
                  const Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        // TextSpan(
                        //   text: '32 ',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontFamily: 'Poppins',
                        //     fontSize: 20,
                        //   ),
                        // ),
                        TextSpan(
                          text: 'FRIENDS',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            height: 3.h,
            width: 1,
            color: Colors.black38,
          ),
          // const VerticalDivider(
          //   color: Colors.black,
          //   thickness: 2,
          // ),
          SizedBox(width: 2.w),
          Expanded(
            child: ReferalButton(userId: userId),
          )
        ],
      ),
    );
  }
}
