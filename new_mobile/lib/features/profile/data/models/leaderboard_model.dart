import 'package:skill_bridge_mobile/features/profile/domain/entities/leaderboard.dart';

import '../../../features.dart';
import 'user_leaderboard_model.dart';

class LeaderboardModel extends Leaderboard {
  const LeaderboardModel({
    required super.userLeaderboardEntities,
    required super.userRank,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      userLeaderboardEntities: (json['leaderboard'] ?? [])
          .map<UserLeaderboardModel>(
            (leaderboard) => UserLeaderboardModel.fromJson(leaderboard),
          )
          .toList(),
      userRank: json['userRank'] == null
          ? null
          : UserLeaderboardRankModel.fromJson(json['userRank']),
    );
  }
}
