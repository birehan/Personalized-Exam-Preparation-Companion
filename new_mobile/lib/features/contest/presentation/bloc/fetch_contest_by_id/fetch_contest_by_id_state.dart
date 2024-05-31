part of 'fetch_contest_by_id_bloc.dart';

class FetchContestByIdState extends Equatable {
  const FetchContestByIdState();

  @override
  List<Object> get props => [];
}

class FetchContestByIdInitial extends FetchContestByIdState {}

class FetchContestByIdLoading extends FetchContestByIdState {}

class FetchContestByIdLoaded extends FetchContestByIdState {
  const FetchContestByIdLoaded({
    required this.contest,
  });

  final Contest contest;

  @override
  List<Object> get props => [contest];
}

class FetchContestByIdFailed extends FetchContestByIdState {}
