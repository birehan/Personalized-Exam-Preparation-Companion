part of 'add_question_bookmark_bloc.dart';

class AddQuestionBookmarkEvent extends Equatable {
  const AddQuestionBookmarkEvent();

  @override
  List<Object> get props => [];
}

class QuestionBookmarkAddedEvent extends AddQuestionBookmarkEvent {
  final String questionId;

  const QuestionBookmarkAddedEvent({required this.questionId});
}
