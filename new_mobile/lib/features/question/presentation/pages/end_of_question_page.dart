import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EndOfQuestionPage extends StatelessWidget {
  const EndOfQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset('assets/images/complete_text_image.png'),
            const Spacer(flex: 5),
            Image.asset('assets/images/star_image.png'),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Congratulations on completing the sub-topic! \nKeep the momentum going, and dive into the next chapter!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
            ),
            const Spacer(flex: 4),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF18786A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      for (int index = 0; index < 4; index++) {
                        context.pop();
                      }
                    },
                    child: Text(
                      'Continue reading',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
