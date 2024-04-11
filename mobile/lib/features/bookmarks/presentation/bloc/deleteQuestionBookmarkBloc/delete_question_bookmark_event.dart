part of 'delete_question_bookmark_bloc.dart';

class DeleteQuestionBookmarkEvent extends Equatable {
  const DeleteQuestionBookmarkEvent();

  @override
  List<Object> get props => [];
}

class QeustionBookmarkDeletedEvent extends DeleteQuestionBookmarkEvent {
  final String questionId;

  const QeustionBookmarkDeletedEvent({required this.questionId});
}
