part of 'users_leaderboard_bloc.dart';

class UsersLeaderboardState extends Equatable {
  const UsersLeaderboardState();

  @override
  List<Object> get props => [];
}

class UsersLeaderboardInitial extends UsersLeaderboardState {}

class UsersLeaderboardLoadingState extends UsersLeaderboardState {}

class UsersLeaderboardNextPageLoadingState extends UsersLeaderboardState {
  final Leaderboard previousLeaderboard;

  const UsersLeaderboardNextPageLoadingState(
      {required this.previousLeaderboard});
}

class UsersLeaderboardLoadedState extends UsersLeaderboardState {
  final Leaderboard topUsers;

  const UsersLeaderboardLoadedState({
    required this.topUsers,
  });
  @override
  List<Object> get props => [topUsers];
}

class UsersLeaderboardFailedState extends UsersLeaderboardState {
  final String errorMessage;
  final Failure failure;

  const UsersLeaderboardFailedState({
    required this.errorMessage,
    required this.failure,
  });
}
