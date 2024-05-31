part of 'contest_ranking_bloc.dart';

class ContestRankingEvent extends Equatable {
  const ContestRankingEvent();

  @override
  List<Object> get props => [];
}

class GetContestRankingEvent extends ContestRankingEvent {
  final String contestId;

  const GetContestRankingEvent({required this.contestId});
}
