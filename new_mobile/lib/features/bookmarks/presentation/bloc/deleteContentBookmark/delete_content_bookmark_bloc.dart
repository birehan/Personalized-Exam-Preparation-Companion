import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/delete_bookmarked_content.dart';

part 'delete_content_bookmark_event.dart';
part 'delete_content_bookmark_state.dart';

class DeleteContentBookmarkBloc
    extends Bloc<DeleteContentBookmarkEvent, DeleteContentBookmarkState> {
  final DeleteContentBookmarkUsecase deleteContentBookmarkUsecase;
  DeleteContentBookmarkBloc({required this.deleteContentBookmarkUsecase})
      : super(DeleteContentBookmarkInitial()) {
    on<BookmarkedContentDeletedEvent>(onBookmarkedContentDeleted);
  }
  onBookmarkedContentDeleted(BookmarkedContentDeletedEvent event,
      Emitter<DeleteContentBookmarkState> emit) async {
    emit(ContnetBookmarkDeletingState());
    Either<Failure, void> response = await deleteContentBookmarkUsecase(
        DeleteContentBookmarkParams(contentId: event.contentId));
    DeleteContentBookmarkState state = response.fold(
        (failure) => ContentBookmarkDeleteErrorState(errorMessage: failure.errorMessage, failure: failure),
        (r) => ContentBookmarkDeletedState());
    emit(state);
  }
}
