part of 'offline_mock_user_score_bloc.dart';

class OfflineMockUserScoreEvent extends Equatable {
  const OfflineMockUserScoreEvent({
    required this.mockId,
    required this.score,
    required this.isCompleted,
  });

  final String mockId;
  final int score;
  final bool isCompleted;

  @override
  List<Object> get props => [mockId, score, isCompleted];
}
