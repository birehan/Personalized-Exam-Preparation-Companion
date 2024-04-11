import 'package:skill_bridge_mobile/core/constants/app_images.dart';

import '../../../features.dart';

class UserLeaderboardRankModel extends UserLeaderboardRank {
  const UserLeaderboardRankModel({
    required super.id,
    required super.rank,
    required super.avatar,
    required super.firstName,
    required super.lastName,
    required super.points,
    required super.maxStreak,
    required super.contestAttended,
  });

  factory UserLeaderboardRankModel.fromJson(Map<String, dynamic> json) {
    return UserLeaderboardRankModel(
      id: json['_id'] ?? '',
      rank: json['rank'] ?? -1,
      avatar: json['avatar'] ?? defaultProfileAvatar,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      points: (json['points'] ?? 0).toInt(),
      maxStreak: json['maxStreak'] ?? 0,
      contestAttended: json['contestAttended'] ?? 0,
    );
  }

  @override
  List<Object> get props => [
        id,
        rank,
        avatar,
        firstName,
        lastName,
        points,
        maxStreak,
        contestAttended,
      ];
}
