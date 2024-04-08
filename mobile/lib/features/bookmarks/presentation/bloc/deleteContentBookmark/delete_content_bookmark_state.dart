part of 'delete_content_bookmark_bloc.dart';

class DeleteContentBookmarkState extends Equatable {
  const DeleteContentBookmarkState();

  @override
  List<Object> get props => [];
}

class DeleteContentBookmarkInitial extends DeleteContentBookmarkState {}

class ContentBookmarkDeletedState extends DeleteContentBookmarkState {}

class ContentBookmarkDeleteErrorState extends DeleteContentBookmarkState {
  final String errorMessage;

  const ContentBookmarkDeleteErrorState({required this.errorMessage});
}

class ContnetBookmarkDeletingState extends DeleteContentBookmarkState {}
