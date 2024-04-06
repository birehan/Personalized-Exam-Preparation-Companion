import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCountDownCard extends StatelessWidget {
  const ShimmerCountDownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF18786A).withOpacity(0.5),
          const Color(0xFF18786A).withOpacity(0.7),
          const Color(0xFF18786A).withOpacity(0.5),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF18786A),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
