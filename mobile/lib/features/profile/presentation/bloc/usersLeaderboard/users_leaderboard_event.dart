part of 'users_leaderboard_bloc.dart';

class UsersLeaderboardEvent extends Equatable {
  const UsersLeaderboardEvent();

  @override
  List<Object> get props => [];
}

class GetTopUsersEvent extends UsersLeaderboardEvent {
  final int pageNumber;

  const GetTopUsersEvent({required this.pageNumber});
}
