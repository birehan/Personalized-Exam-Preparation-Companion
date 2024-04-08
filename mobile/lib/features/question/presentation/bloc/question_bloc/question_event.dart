part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class QuestionAnswerEvent extends QuestionEvent {
  final List<QuestionUserAnswer> questionUserAnswers;

  const QuestionAnswerEvent({
    required this.questionUserAnswers,
  });

  @override
  List<Object> get props => [questionUserAnswers];
}

class EndSubtopicQuestionAnswerEvent extends QuestionEvent {
  final String subtopicId;

  const EndSubtopicQuestionAnswerEvent({
    required this.subtopicId,
  });

  @override
  List<Object> get props => [subtopicId];
}
