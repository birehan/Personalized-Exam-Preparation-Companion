import 'package:equatable/equatable.dart';

import '../../../features.dart';

class DailyStreak extends Equatable {
  final List<UserDailyStreak> userDailyStreaks;
  final TotalStreak totalStreak;

  const DailyStreak({
    required this.userDailyStreaks,
    required this.totalStreak,
  });

  @override
  List<Object?> get props => [userDailyStreaks, totalStreak];
}
