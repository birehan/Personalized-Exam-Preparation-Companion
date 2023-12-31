import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/top_ranked_profiles.dart';

class TopRankedDetail extends StatelessWidget {
  const TopRankedDetail(
      {super.key,
      required this.diameter,
      required this.color,
      required this.badgeDiameter,
      required this.rank,
      required this.imageUrl,
      required this.name,
      required this.point});

  final double diameter;
  final Color color;
  final double badgeDiameter;
  final int rank;
  final String imageUrl;
  final String name;
  final int point;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TopRankedProfiles(
            diameter: diameter,
            color: color,
            badgeDiameter: badgeDiameter,
            rank: rank,
            imageUrl: imageUrl),
        SizedBox(height: rank == 1 ? 2.h : 1.h),
        SizedBox(
          width: 30.w,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: .5.h),
        Text(
          point.toString(),
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: .5.h),
        const Text('points',
            style: TextStyle(fontSize: 16, fontFamily: 'Poppins'))
      ],
    );
  }
}
