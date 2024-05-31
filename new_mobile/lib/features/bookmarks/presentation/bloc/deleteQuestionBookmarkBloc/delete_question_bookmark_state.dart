part of 'delete_question_bookmark_bloc.dart';

class DeleteQuestionBookmarkState extends Equatable {
  const DeleteQuestionBookmarkState();

  @override
  List<Object> get props => [];
}

class DeleteQuestionBookmarkInitial extends DeleteQuestionBookmarkState {}

class DeleteQuestionBookmarkSuccessState extends DeleteQuestionBookmarkState {}

class DeleteQuestionBookmarkError extends DeleteQuestionBookmarkState {
  final Failure failure;
  const DeleteQuestionBookmarkError({required this.failure});
}

class DeleteQuestionBookmarkLoading extends DeleteQuestionBookmarkState {}
