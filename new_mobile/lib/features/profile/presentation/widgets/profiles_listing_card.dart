import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilesListingCard extends StatelessWidget {
  const ProfilesListingCard({
    super.key,
    required this.leftWidget,
    required this.data,
  });
  final Widget leftWidget;
  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                // image: NetworkImage(data['image']!),
                image: CachedNetworkImageProvider(data['image']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name']!,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: .5.h),
                Text(
                  '${data['points']!} points',
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
          leftWidget,
        ],
      ),
    );
  }
}
