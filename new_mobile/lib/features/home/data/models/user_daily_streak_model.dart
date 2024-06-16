import '../../../features.dart';

class UserDailyStreakModel extends UserDailyStreak {
  const UserDailyStreakModel({
    required super.date,
    required super.activeOnDay,
  });

  factory UserDailyStreakModel.fromJson(Map<String, dynamic> json) {
    return UserDailyStreakModel(
      date: (DateTime.tryParse(json['date']) ?? DateTime.now()),
      activeOnDay: json['activeOnDay'],
    );
  }
}
