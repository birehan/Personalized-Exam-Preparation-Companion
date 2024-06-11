import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/utils/same_day.dart';
import 'package:prep_genie/core/widgets/tooltip_widget.dart';
import 'package:prep_genie/features/home/domain/entities/user_daily_streak.dart';
import 'package:prep_genie/features/home/presentation/bloc/fetch_daily_streak/fetch_daily_streak_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DailyStreakWidgetDesctiptionWidget extends StatelessWidget {
  const DailyStreakWidgetDesctiptionWidget({
    super.key,
    required this.userDailyStreakMap,
    required this.today,
    required this.setToday,
  });

  final Map<String, UserDailyStreak> userDailyStreakMap;
  final DateTime today;
  final Function setToday;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.daily_streak,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(width: 1.w),
              Text(
                '(${DateFormat('MMM dd').format(userDailyStreakMap['1']!.date)} - ${DateFormat('MMM dd').format(userDailyStreakMap['7']!.date)})',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF7D7D7D),
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              if (!isSameDay(today, DateTime.now()))
                InkWell(
                  onTap: () {
                    setToday();
                    DateTime mondayBefore =
                        today.subtract(Duration(days: today.weekday - 1));
                    DateTime sundayAfter =
                        today.add(Duration(days: 7 - today.weekday));
                    context.read<FetchDailyStreakBloc>().add(
                        FetchDailyStreakEvent(
                            startDate: mondayBefore, endDate: sundayAfter));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18786A).withOpacity(0.11),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Today',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF18786A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          TooltipWidget(
            message: AppLocalizations.of(context)!.daily_streak_info,
          )
        ],
      ),
    );
  }
}
