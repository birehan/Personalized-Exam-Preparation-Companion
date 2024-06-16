import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';

class UserLeaderboardModel extends UserLeaderboardEntity {
  const UserLeaderboardModel({
    required super.userId,
    required super.firstName,
    required super.overallRank,
    required super.overallPoints,
    required super.userAvatar,
    required super.lastName,
    required super.maxStreak,
    required super.contestAttended,
  });
  factory UserLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return UserLeaderboardModel(
      overallRank: 0,
      overallPoints: (json['points'] ?? 0).toInt(),
      userAvatar: json['avatar'] ?? defaultProfileAvatar,
      firstName: json['firstName'] ?? 0,
      lastName: json['lastName'] ?? 0,
      maxStreak: json['maxStreak'] ?? 0,
      contestAttended: json['contestAttended'] ?? 0,
      userId: json['_id'] ?? '',
    );
  }
}
