import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';

class NewPasswordConfirmedPage extends StatelessWidget {
  const NewPasswordConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            const Spacer(),
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF0072FF),
              size: 72,
            ),
            const SizedBox(height: 12),
            Text(
              'New password confirmed successfully',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF363636),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You have successfully confirm your new password. Please, use your new password when logging in.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5E5E5E),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF0072FF),
                    ),
                    onPressed: () {
                      LoginPageRoute().go(context);
                      // context.go(AppRoutes.login);
                    },
                    child: Text(
                      'Okay',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
