part of 'upsert_mock_score_bloc.dart';

class UpsertMockScoreState extends Equatable {
  const UpsertMockScoreState();

  @override
  List<Object> get props => [];
}

class UpsertMockScoreInitial extends UpsertMockScoreState {}

class UpsertMyMockScoreState extends UpsertMockScoreState {
  final MockExamStatus status;
  final Failure? failure;

  const UpsertMyMockScoreState({
    required this.status,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}
