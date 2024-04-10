part of 'quiz_question_bloc.dart';

abstract class QuizQuestionState extends Equatable {
  const QuizQuestionState();

  @override
  List<Object> get props => [];
}

class QuizQuestionInitial extends QuizQuestionState {}

enum QuizQuestionStatus { loading, loaded, error }

class GetQuizByIdState extends QuizQuestionState {
  final QuizQuestionStatus status;
  final QuizQuestion? quizQuestion;

  const GetQuizByIdState({
    required this.status,
    this.quizQuestion,
  });

  @override
  List<Object> get props => [status];
}

class GetQuizAnalysisState extends QuizQuestionState {
  final QuizQuestionStatus status;
  final QuizQuestion? quizQuestion;

  const GetQuizAnalysisState({
    required this.status,
    this.quizQuestion,
  });

  @override
  List<Object> get props => [status];
}

class SaveQuizScoreState extends QuizQuestionState {
  final QuizQuestionStatus status;

  const SaveQuizScoreState({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}
