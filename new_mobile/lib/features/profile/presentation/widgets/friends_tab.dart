import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/constants/app_images.dart';
import 'package:skill_bridge_mobile/core/constants/dummydata.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/profiles_listing_card.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => ProfilesListingCard(
        data: dummyUsers[index],
        leftWidget: const Icon(
          Icons.keyboard_arrow_right,
          size: 25,
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(
        height: 2.h,
      ),
      itemCount: 6,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}
