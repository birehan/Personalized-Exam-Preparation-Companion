import '../../../features.dart';

class TotalStreakModel extends TotalStreak {
  const TotalStreakModel({
    required super.maxStreak,
    required super.currentStreak,
    required super.points,
  });

  factory TotalStreakModel.fromJson(Map<String, dynamic> json) {
    return TotalStreakModel(
      maxStreak: json['maxStreak'],
      currentStreak: json['currentStreak'],
      points: json['points'],
    );
  }
}
