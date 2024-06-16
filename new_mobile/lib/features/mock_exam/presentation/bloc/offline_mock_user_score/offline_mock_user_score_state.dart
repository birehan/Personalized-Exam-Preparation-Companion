part of 'offline_mock_user_score_bloc.dart';

class OfflineMockUserScoreState extends Equatable {
  const OfflineMockUserScoreState();

  @override
  List<Object> get props => [];
}

class OfflineMockUserScoreInitial extends OfflineMockUserScoreState {}

class OfflineMockUserScoreLoading extends OfflineMockUserScoreState {}

class OfflineMockUserScoreLoaded extends OfflineMockUserScoreState {}

class OfflineMockUserScoreFailed extends OfflineMockUserScoreState {
  const OfflineMockUserScoreFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
