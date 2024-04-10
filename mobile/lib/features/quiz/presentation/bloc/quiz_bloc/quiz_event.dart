part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class GetUserQuizEvent extends QuizEvent {
  const GetUserQuizEvent({
    required this.courseId,
    required this.isRefreshed, 
  });

  final String courseId;
  final bool isRefreshed;

  @override
  List<Object> get props => [courseId, isRefreshed];
}
