import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedEmptyListWidget extends StatelessWidget {
  const RecommendedEmptyListWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
   
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/no_data_image.png',
          width: 128,
          height: 128,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.you_have_no_recommended_mocks,
            style: GoogleFonts.poppins(
            color: const Color(0xFF797979),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          ),
        ],
      ),
    );
  }
}
