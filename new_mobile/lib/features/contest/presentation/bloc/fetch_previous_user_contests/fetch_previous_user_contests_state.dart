part of 'fetch_previous_user_contests_bloc.dart';

class FetchPreviousUserContestsState extends Equatable {
  const FetchPreviousUserContestsState();

  @override
  List<Object> get props => [];
}

class FetchPreviousUserContestsInitial extends FetchPreviousUserContestsState {}

class FetchPreviousUserContestsLoading extends FetchPreviousUserContestsState {}

class FetchPreviousUserContestsLoaded extends FetchPreviousUserContestsState {
  const FetchPreviousUserContestsLoaded({
    required this.contests,
  });

  final List<Contest> contests;

  @override
  List<Object> get props => [contests];
}

class FetchPreviousUserContestsFailed extends FetchPreviousUserContestsState {
  final Failure failure;

  const FetchPreviousUserContestsFailed({required this.failure});
}
