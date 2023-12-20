import 'package:skill_bridge_mobile/features/profile/domain/entities/user_leaderboard_entity.dart';

class UserLeaderboardModel extends UserLeaderboardEntity {
  const UserLeaderboardModel({
    required super.firstName,
    required super.overallRank,
    required super.overallPoints,
    required super.userAvatar,
    required super.lastName,
  });
  factory UserLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return UserLeaderboardModel(
      overallRank: 0,
      overallPoints: json['totalScore'] ?? 0,
      userAvatar: json['avatar'] ??
          'https://res.cloudinary.com/demo/image/upload/d_avatar.png/non_existing_id.png',
      firstName: json['firstName'] ?? 0,
      lastName: json['lastName'] ?? 0,
    );
  }
}
