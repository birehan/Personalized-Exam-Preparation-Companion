part of 'add_content_bookmark_bloc_bloc.dart';

class AddContentBookmarkBlocEvent extends Equatable {
  const AddContentBookmarkBlocEvent();

  @override
  List<Object> get props => [];
}

class ContentBookmarkAddedEvent extends AddContentBookmarkBlocEvent {
  final String contentId;

  const ContentBookmarkAddedEvent({required this.contentId});
  @override
  List<Object> get props => [contentId];
}
