import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/constants/app_images.dart';
import 'package:prep_genie/core/constants/dummydata.dart';
import 'package:prep_genie/features/profile/presentation/widgets/profiles_listing_card.dart';

class SentFriendRequestsTab extends StatelessWidget {
  const SentFriendRequestsTab({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return ProfilesListingCard(
      data: dummyUsers[index],
      leftWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffD9D9D9),
        ),
        child: const Text(
          'WITHDRAW',
          style: TextStyle(
            color: Color(0xff2B2B2B),
          ),
        ),
      ),
    );
  }
}
