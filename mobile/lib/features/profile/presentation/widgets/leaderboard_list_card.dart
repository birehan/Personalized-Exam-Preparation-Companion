import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaderboardListCard extends StatelessWidget {
  const LeaderboardListCard({
    super.key,
    required this.userData,
    required this.rank,
    required this.points,
    required this.imageUrl,
    required this.name,
  });
  final int rank;
  final int points;
  final bool userData;
  final String imageUrl;
  final String name;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 1.h,
      selected: userData,
      selectedTileColor: const Color(0xffD1DFDD),
      title: Row(
        children: [
          Text(
            rank.toString(),
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: userData ? Colors.black : Colors.black87,
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(imageUrl))),
          ),
          SizedBox(width: 4.w),
          Text(
            name,
            style: const TextStyle(
                color: Colors.black87,
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.clip,
          ),
        ],
      ),
      trailing: Text(
        points.toString(),
        style: TextStyle(
            color: userData ? Colors.black87 : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: userData ? 25 : 20,
            fontFamily: 'Poppins'),
      ),
      minLeadingWidth: 4.w,
    );
  }
}
