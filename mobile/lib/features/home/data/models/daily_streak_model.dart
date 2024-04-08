import '../../../features.dart';

class DailyStreakModel extends DailyStreak {
  const DailyStreakModel({
    required super.userDailyStreaks,
    required super.totalStreak,
  });

  factory DailyStreakModel.fromJson(Map<String, dynamic> json) {
    return DailyStreakModel(
      userDailyStreaks: (json['userDailyStreak'] ?? [])
          .map<UserDailyStreakModel>(
            (userDailyStreak) => UserDailyStreakModel.fromJson(userDailyStreak),
          )
          .toList(),
      totalStreak: TotalStreakModel.fromJson(json['totalStreak']),
    );
  }
}
