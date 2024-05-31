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
  final Failure? failure;

  const QuestionUserState({
    required this.status,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}

class EndSubtopicQuestionUserState extends QuestionState {
  final QuestionStatus status;
  final List<EndQuestionsAndAnswer>? endSubtopicQuestionAnswer;
  final Failure? failure;

  const EndSubtopicQuestionUserState({
    required this.status,
    this.endSubtopicQuestionAnswer,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}
