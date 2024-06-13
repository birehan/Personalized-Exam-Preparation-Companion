import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
              AppLocalizations.of(context)!.new_password_confirmed_successfully,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF363636),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context)!
                  .you_have_successfully_confirm_your_new_password_please_use_your_new_password_when_logging_in,
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
                    },
                    child: Text(
                      AppLocalizations.of(context)!.okay,
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
