import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/utils/same_day.dart';
import 'package:skill_bridge_mobile/features/home/domain/entities/user_daily_streak.dart';
import 'package:skill_bridge_mobile/features/home/presentation/bloc/fetch_daily_streak/fetch_daily_streak_bloc.dart';

class DailyStreakWithDaysWidget extends StatelessWidget {
  const DailyStreakWithDaysWidget({
    super.key,
    required this.today,
    required this.userDailyStreakMap,
    required this.days,
    required this.previousWeek,
    required this.upcomingWeek,
  });

  final DateTime today;
  final Map<String, UserDailyStreak> userDailyStreakMap;
  final List<String> days;
  final Function previousWeek;
  final Function upcomingWeek;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            previousWeek();
            DateTime mondayBefore =
                today.subtract(Duration(days: today.weekday - 1));
            DateTime sundayAfter = today.add(Duration(days: 7 - today.weekday));
            context.read<FetchDailyStreakBloc>().add(FetchDailyStreakEvent(
                startDate: mondayBefore, endDate: sundayAfter));
          },
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        Expanded(
          child: SizedBox(
            height: 10.h,
            child: ListView.separated(
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => Container(
                width: 5.w,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 2.8.h),
                child: Container(
                    height: 1,
                    color: !userDailyStreakMap['${index + 1}']!.activeOnDay
                        ? const Color.fromARGB(255, 214, 213, 213)
                        : const Color(0xffF53A04)),
              ),
              itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index],
                    style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 1.h),
                  Image(
                      image: userDailyStreakMap['${index + 1}']!.activeOnDay
                          ? const AssetImage('assets/images/fireRed.png')
                          : const AssetImage('assets/images/fireGrey.png'),
                      height: 25,
                      width: 25),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: isSameDay(today, DateTime.now())
              ? null
              : () {
                  upcomingWeek();
                  DateTime mondayBefore =
                      today.subtract(Duration(days: today.weekday - 1));
                  DateTime sundayAfter =
                      today.add(Duration(days: 7 - today.weekday));
                  context.read<FetchDailyStreakBloc>().add(
                      FetchDailyStreakEvent(
                          startDate: mondayBefore, endDate: sundayAfter));
                },
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
