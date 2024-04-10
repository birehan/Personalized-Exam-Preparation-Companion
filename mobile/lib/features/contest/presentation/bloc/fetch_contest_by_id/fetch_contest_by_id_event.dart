part of 'fetch_contest_by_id_bloc.dart';

class FetchContestByIdEvent extends Equatable {
  const FetchContestByIdEvent({
    required this.contestId,
  });

  final String contestId;

  @override
  List<Object> get props => [contestId];
}
