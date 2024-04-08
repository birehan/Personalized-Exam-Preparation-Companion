part of 'delete_content_bookmark_bloc.dart';

class DeleteContentBookmarkEvent extends Equatable {
  const DeleteContentBookmarkEvent();

  @override
  List<Object> get props => [];
}

class BookmarkedContentDeletedEvent extends DeleteContentBookmarkEvent {
  final String contentId;

  const BookmarkedContentDeletedEvent({required this.contentId});
}
