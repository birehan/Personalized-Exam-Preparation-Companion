part of 'users_leaderboard_bloc.dart';

class UsersLeaderboardEvent extends Equatable {
  const UsersLeaderboardEvent();

  @override
  List<Object> get props => [];
}

enum LeaderboardType {
  weekly,
  monthly,
  allTime,
}

class GetTopUsersEvent extends UsersLeaderboardEvent {
  final int pageNumber;
  final LeaderboardType leaderboardType;

  const GetTopUsersEvent({
    required this.pageNumber,
    required this.leaderboardType,
  });
}
