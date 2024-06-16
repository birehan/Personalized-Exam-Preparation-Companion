import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features.dart';

class SendAgainWidget extends StatelessWidget {
  const SendAgainWidget({
    super.key,
    required this.emailOrPhoneNumber,
  });

  final String emailOrPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AuthenticationBloc>().add(
              ResendOtpVerificationEvent(
                emailOrPhoneNumber: emailOrPhoneNumber,
              ),
            );
      },
      child: Text(
        AppLocalizations.of(context)!.send_again,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0072FF),
        ),
      ),
    );
  }
}
