part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

enum QuizStatus { loading, loaded, error }

class GetUserQuizState extends QuizState {
  final QuizStatus status;
  final List<Quiz>? quizzes;
  final String? errorMessage;

  const GetUserQuizState({
    this.errorMessage,
    required this.status,
    this.quizzes,
  });

  @override
  List<Object?> get props => [status, errorMessage, quizzes];
}
