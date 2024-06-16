part of 'offline_mock_user_answer_bloc.dart';

class OfflineMockUserAnswerEvent extends Equatable {
  const OfflineMockUserAnswerEvent({
    required this.mockId,
    required this.userAnswers,
  });

  final String mockId;
  final List<QuestionUserAnswer> userAnswers;

  @override
  List<Object> get props => [mockId, userAnswers];
}
