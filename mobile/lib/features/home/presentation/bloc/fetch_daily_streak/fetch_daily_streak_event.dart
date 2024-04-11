part of 'fetch_daily_streak_bloc.dart';

class FetchDailyStreakEvent extends Equatable {
  const FetchDailyStreakEvent({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object> get props => [startDate, endDate];
}
