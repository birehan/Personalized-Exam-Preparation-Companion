part of 'upsert_mock_score_bloc.dart';

class UpsertMockScoreEvent extends Equatable {
  const UpsertMockScoreEvent();

  @override
  List<Object> get props => [];
}

class UpsertMyMockScoreEvent extends UpsertMockScoreEvent {
  final String mockId;
  final int score;

  const UpsertMyMockScoreEvent({
    required this.mockId,
    required this.score,
  });

  @override
  List<Object> get props => [
        mockId,
        score,
      ];
}
