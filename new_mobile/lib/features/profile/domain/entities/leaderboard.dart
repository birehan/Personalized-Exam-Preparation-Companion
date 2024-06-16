import 'package:equatable/equatable.dart';
import '../../../features.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';

class Leaderboard extends Equatable {
  final List<UserLeaderboardEntity> userLeaderboardEntities;
  final UserLeaderboardRank? userRank;

  const Leaderboard({
    required this.userLeaderboardEntities,
    required this.userRank,
  });

  @override
  List<Object?> get props => [userLeaderboardEntities, userRank];
}
