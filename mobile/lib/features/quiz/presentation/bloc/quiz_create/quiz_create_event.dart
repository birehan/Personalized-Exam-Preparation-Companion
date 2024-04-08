part of 'quiz_create_bloc.dart';

abstract class QuizCreateEvent extends Equatable {
  const QuizCreateEvent();

  @override
  List<Object> get props => [];
}

class CreateQuizEvent extends QuizCreateEvent {
  final String name;
  final List<String> chapters;
  final int numberOfQuestions;
  final String courseId;

  const CreateQuizEvent({
    required this.name,
    required this.chapters,
    required this.numberOfQuestions,
    required this.courseId,
  });

  @override
  List<Object> get props => [
        name,
        chapters,
        numberOfQuestions,
        courseId,
      ];
}

