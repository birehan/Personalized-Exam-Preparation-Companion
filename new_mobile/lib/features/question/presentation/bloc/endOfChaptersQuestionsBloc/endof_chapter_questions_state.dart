part of 'endof_chapter_questions_bloc.dart';

class EndofChapterQuestionsState extends Equatable {
  const EndofChapterQuestionsState();

  @override
  List<Object> get props => [];
}

class EndofChapterQuestionsInitial extends EndofChapterQuestionsState {}

class EndofChapterQuestionsLoadingState extends EndofChapterQuestionsState {}

class EndofChapterQuestionsSuccessState extends EndofChapterQuestionsState {
  final List<EndQuestionsAndAnswer> endSubtopicQuestionAnswers;

  const EndofChapterQuestionsSuccessState(
      {required this.endSubtopicQuestionAnswers});
  @override
  List<Object> get props => [endSubtopicQuestionAnswers];
}

class EndofChapterQuestionsErrorState extends EndofChapterQuestionsState {
  final String errorMessage;
  final Failure failure;

  const EndofChapterQuestionsErrorState({required this.errorMessage, required this.failure});
}
