part of 'fetch_previous_contests_bloc.dart';

class FetchPreviousContestsState extends Equatable {
  const FetchPreviousContestsState();

  @override
  List<Object> get props => [];
}

class FetchPreviousContestsInitial extends FetchPreviousContestsState {}

class FetchPreviousContestsLoading extends FetchPreviousContestsState {}

class FetchPreviousContestsLoaded extends FetchPreviousContestsState {
  const FetchPreviousContestsLoaded({
    required this.contests,
  });

  final List<Contest> contests;

  @override
  List<Object> get props => [contests];
}

class FetchPreviousContestsFailed extends FetchPreviousContestsState {
  final Failure failure;
  const FetchPreviousContestsFailed({required this.failure});
}
