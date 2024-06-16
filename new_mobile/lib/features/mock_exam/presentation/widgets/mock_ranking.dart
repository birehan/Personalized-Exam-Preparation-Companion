import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features.dart';

class MockRanking extends StatelessWidget {
  const MockRanking({
    super.key,
    required this.mockUserRanks,
    required this.numberOfQuestions,
  });

  final List<MockUserRank> mockUserRanks;
  final int numberOfQuestions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 24, bottom: 8, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top scores',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'RANK',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF7D7D7D),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'NAME',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF7D7D7D),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  'SCORE',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF7D7D7D),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    mockUserRanks.length,
                    (index) => MockRankCard(
                      numberOfQuestions: numberOfQuestions,
                      userRank: mockUserRanks[index],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
