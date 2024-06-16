import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/constants/app_images.dart';
import 'package:prep_genie/core/constants/dummydata.dart';
import 'package:prep_genie/features/profile/presentation/widgets/profiles_listing_card.dart';

class ReceicedRequestsTab extends StatelessWidget {
  const ReceicedRequestsTab({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        children: [
          ProfilesListingCard(
            data: dummyUsers[index],
            leftWidget: const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AcceptDeclineWidget(
                color: const Color(0xFF0072FF),
                onClick: () {
                  // trigger accept
                },
                textColor: Colors.white,
                title: 'ACCEPT',
              ),
              AcceptDeclineWidget(
                color: const Color(0xffD9D9D9),
                onClick: () {
                  // trigger decline
                },
                textColor: Colors.black,
                title: 'DECLINE',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AcceptDeclineWidget extends StatelessWidget {
  const AcceptDeclineWidget({
    super.key,
    required this.color,
    required this.title,
    required this.onClick,
    required this.textColor,
  });
  final Color color;
  final String title;
  final Color textColor;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 4.3.h,
        width: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
