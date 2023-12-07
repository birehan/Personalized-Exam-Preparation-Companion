part of 'quiz_create_bloc.dart';

abstract class QuizCreateState extends Equatable {
  const QuizCreateState();

  @override
  List<Object> get props => [];
}

class QuizCreateInitial extends QuizCreateState {}

enum QuizCreateStatus { loading, loaded, error }

class CreateQuizState extends QuizCreateState {
  final QuizCreateStatus status;
  final String? quizId;
  final String? errorMessage;

  const CreateQuizState({
    required this.status,
    this.quizId,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}
