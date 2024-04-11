import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prepgenie/core/routes/go_routes.dart';

class TopRankedProfiles extends StatelessWidget {
  const TopRankedProfiles(
      {super.key,
      required this.diameter,
      required this.color,
      required this.userId,
      required this.badgeDiameter,
      required this.rank,
      required this.imageUrl});
  final String userId;
  final double diameter;
  final Color color;
  final double badgeDiameter;
  final int rank;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        LeaderboardDetailPageRoute(userId: userId).go(context);
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: badgeDiameter - 1.h),
            child: Container(
              height: diameter,
              width: diameter,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 3),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(imageUrl))),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              alignment: Alignment.center,
              height: badgeDiameter,
              width: badgeDiameter,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text(
                rank.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
