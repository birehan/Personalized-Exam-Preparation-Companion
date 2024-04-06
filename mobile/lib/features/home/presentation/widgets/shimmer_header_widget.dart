import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHeaderWidget extends StatelessWidget {
  const ShimmerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(211, 211, 211, 1), // Light Grey
              Color.fromRGBO(192, 192, 192, 1), // Medium Grey
              Color.fromRGBO(211, 211, 211, 1),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Shimmer(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(211, 211, 211, 1), // Light Grey
              Color.fromRGBO(192, 192, 192, 1), // Medium Grey
              Color.fromRGBO(211, 211, 211, 1),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
