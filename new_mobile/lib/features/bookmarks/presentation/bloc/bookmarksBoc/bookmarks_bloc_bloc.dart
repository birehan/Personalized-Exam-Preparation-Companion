import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';

part 'bookmarks_bloc_event.dart';
part 'bookmarks_bloc_state.dart';

class BookmarksBlocBloc extends Bloc<BookmarksBlocEvent, BookmarksBlocState> {
  final GetUserBookmarksUsecase getUserBookmarksUsecase;
  BookmarksBlocBloc({required this.getUserBookmarksUsecase})
      : super(BookmarksBlocInitial()) {
    on<GetBookmarksEvent>(onGetBookmarks);
  }
  void onGetBookmarks(
      GetBookmarksEvent event, Emitter<BookmarksBlocState> emit) async {
    emit(BookmarksLoadingState());
    Either<Failure, Bookmarks> response =
        await getUserBookmarksUsecase(NoParams());

    emit(_eitherFailureOrBookmarks(response));
  }

  BookmarksBlocState _eitherFailureOrBookmarks(
      Either<Failure, Bookmarks> response) {
    return response.fold(
        (l) => BookmarksErrorState(errorMessage: l.errorMessage, failure: l),
        (r) => BookmarksLoadedState(bookmarks: r));
  }
}
