part of 'contest_ranking_bloc.dart';

class ContestRankingState extends Equatable {
  const ContestRankingState();

  @override
  List<Object> get props => [];
}

class ContestRankingInitial extends ContestRankingState {}

class ContestRankingLoadedState extends ContestRankingState {
  final ContestRank ranking;
  const ContestRankingLoadedState({required this.ranking});
}

class ContestRankingLoadingState extends ContestRankingState {}

class ContestRankingFailedState extends ContestRankingState {
  final Failure failureType;

  const ContestRankingFailedState({required this.failureType});
}
