part of 'bookmarks_bloc_bloc.dart';

class BookmarksBlocState extends Equatable {
  const BookmarksBlocState();

  @override
  List<Object> get props => [];
}

class BookmarksBlocInitial extends BookmarksBlocState {}

class BookmarksLoadedState extends BookmarksBlocState {
  final Bookmarks bookmarks;

  const BookmarksLoadedState({required this.bookmarks});
  @override
  List<Object> get props => [bookmarks];
}

class BookmarksLoadingState extends BookmarksBlocState {}

class BookmarksErrorState extends BookmarksBlocState {
  final String errorMessage;
  final Failure failure;
  const BookmarksErrorState(
      {required this.errorMessage, required this.failure});
  @override
  List<Object> get props => [errorMessage];
}
