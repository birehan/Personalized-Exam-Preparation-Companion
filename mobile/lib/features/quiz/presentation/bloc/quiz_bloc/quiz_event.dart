part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class GetUserQuizEvent extends QuizEvent {
  const GetUserQuizEvent({
    required this.courseId,
  });

  final String courseId;

  @override
  List<Object> get props => [courseId];
}
