part of 'fetch_upcoming_user_contest_bloc.dart';

class FetchUpcomingUserContestState extends Equatable {
  const FetchUpcomingUserContestState();

  @override
  List<Object?> get props => [];
}

class FetchUpcomingUserContestInitial extends FetchUpcomingUserContestState {}

class UpcomingContestFetchedState extends FetchUpcomingUserContestState {
  final Contest? upcomingContes;

  const UpcomingContestFetchedState({required this.upcomingContes});
  @override
  List<Object?> get props => [upcomingContes];
}

class UpcomingContestLoadingState extends FetchUpcomingUserContestState {}

class UpcomingContestFailredState extends FetchUpcomingUserContestState {
  final Failure failureType;

  const UpcomingContestFailredState({required this.failureType});
}
