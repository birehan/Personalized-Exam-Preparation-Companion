part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

enum QuestionStatus { loading, loaded, error }

class QuestionUserState extends QuestionState {
  final QuestionStatus status;

  const QuestionUserState({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}

class EndSubtopicQuestionUserState extends QuestionState {
  final QuestionStatus status;
  final List<EndQuestionsAndAnswer>? endSubtopicQuestionAnswer;

  const EndSubtopicQuestionUserState({
    required this.status,
    this.endSubtopicQuestionAnswer,
  });

  @override
  List<Object> get props => [status];
}
