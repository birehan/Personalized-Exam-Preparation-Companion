import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/utils/get_ordinal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeeklyPrizeDisplay extends StatelessWidget {
  const WeeklyPrizeDisplay({
    super.key,
    required this.place,
    required this.prizeMoney,
  });

  final int place;
  final double prizeMoney;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Text(
            '${getOrdinal(place)} ${AppLocalizations.of(context)!.place}', 
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            NumberFormat.compact().format(prizeMoney),
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            'assets/images/cash.png',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
