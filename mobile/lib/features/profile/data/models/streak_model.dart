import 'package:skill_bridge_mobile/features/profile/domain/entities/streak_entity.dart';

class StreakModel extends StreakEntity {
  const StreakModel({
    required super.maxStreak,
    required super.currentStreak,
    required super.points,
  });
  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      maxStreak: json['maxStreak'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      points: json['points'] ?? 0,
    );
  }
}
