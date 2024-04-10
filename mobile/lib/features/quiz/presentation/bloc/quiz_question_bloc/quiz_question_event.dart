part of 'quiz_question_bloc.dart';

abstract class QuizQuestionEvent extends Equatable {
  const QuizQuestionEvent();

  @override
  List<Object> get props => [];
}

class GetQuizByIdEvent extends QuizQuestionEvent {
  final String quizId;
  final bool isRefreshed;

  const GetQuizByIdEvent({
    required this.quizId,
    required this.isRefreshed,
  });

  @override
  List<Object> get props => [quizId, isRefreshed];
}

class GetQuizAnalysisEvent extends QuizQuestionEvent {
  final String quizId;

  const GetQuizAnalysisEvent({required this.quizId});

  @override
  List<Object> get props => [quizId];
}

class SaveQuizScoreEvent extends QuizQuestionEvent {
  final String quizId;
  final int score;

  const SaveQuizScoreEvent({
    required this.quizId,
    required this.score,
  });

  @override
  List<Object> get props => [
        quizId,
        score,
      ];
}
