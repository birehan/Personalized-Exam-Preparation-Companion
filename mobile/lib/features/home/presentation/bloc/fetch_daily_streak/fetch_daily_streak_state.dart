part of 'fetch_daily_streak_bloc.dart';

class FetchDailyStreakState extends Equatable {
  const FetchDailyStreakState();

  @override
  List<Object> get props => [];
}

class FetchDailyStreakInitial extends FetchDailyStreakState {}

class FetchDailyStreakLoading extends FetchDailyStreakState {}

class FetchDailyStreakLoaded extends FetchDailyStreakState {
  const FetchDailyStreakLoaded({
    required this.dailyStreak,
  });

  final DailyStreak dailyStreak;

  @override
  List<Object> get props => [dailyStreak];
}

class FetchDailyStreakFailed extends FetchDailyStreakState {
  const FetchDailyStreakFailed({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
