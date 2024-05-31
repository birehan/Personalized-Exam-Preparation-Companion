import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserMockRank extends StatelessWidget {
  const UserMockRank({
    super.key,
    required this.isCompleted,
    this.rank,
    this.numberOfCorrectAnswers,
  });

  final bool isCompleted;
  final int? rank;
  final int? numberOfCorrectAnswers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check, color: Color(0xFF1A7A6C)),
                const SizedBox(height: 16),
                isCompleted == true
                    ? Text(
                        '$numberOfCorrectAnswers',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      )
                    : Row(
                        children: [
                          Container(width: 12, height: 6, color: Colors.black),
                          const SizedBox(width: 6),
                          Container(width: 12, height: 6, color: Colors.black),
                        ],
                      ),
                const SizedBox(height: 12),
                Text(
                  'Number of correct answers',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Transform.rotate(
              angle: -math.pi / 2,
              child: const Divider(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/images/leaderboard_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                isCompleted
                    ? Text(
                        '$rank',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      )
                    : Row(
                        children: [
                          Container(width: 12, height: 6, color: Colors.black),
                          const SizedBox(width: 6),
                          Container(width: 12, height: 6, color: Colors.black),
                        ],
                      ),
                const SizedBox(height: 12),
                Text(
                  'Your rank among students',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
