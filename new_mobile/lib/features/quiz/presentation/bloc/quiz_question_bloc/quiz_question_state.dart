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
  final Failure? failure;

  const GetQuizByIdState({
    required this.status,
    this.quizQuestion,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}

class GetQuizAnalysisState extends QuizQuestionState {
  final QuizQuestionStatus status;
  final QuizQuestion? quizQuestion;
  final Failure? failure;

  const GetQuizAnalysisState({
    required this.status,
    this.quizQuestion,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}

class SaveQuizScoreState extends QuizQuestionState {
  final QuizQuestionStatus status;
  final Failure? failure;

  const SaveQuizScoreState({
    required this.status,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}
