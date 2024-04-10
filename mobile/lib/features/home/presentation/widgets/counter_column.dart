import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterColumn extends StatelessWidget {
  const CounterColumn({
    super.key,
    required this.countDown,
    required this.label,
  });

  final String countDown;
  final String label;

  @override
  Widget build(BuildContext context) {
    final countDownList = countDown.split('');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: List.generate(
            countDownList.length,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                width: 32,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Center(
                  child: Text(
                    countDownList[index],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 50,
        //   width: countDownList.length == 2 ? 75 : 100,
        //   child: ListView.separated(
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) => Container(
        //       decoration: BoxDecoration(
        //         color: const Color.fromRGBO(255, 255, 255, 0.3),
        //         borderRadius: BorderRadius.circular(6),
        //       ),
        //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        //       child: Text(
        //         countDownList[index],
        //         style: GoogleFonts.poppins(
        //           color: Colors.white,
        //           fontSize: 28,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //     separatorBuilder: (context, index) => const SizedBox(width: 8),
        //     itemCount: countDownList.length,
        //   ),
        // ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
