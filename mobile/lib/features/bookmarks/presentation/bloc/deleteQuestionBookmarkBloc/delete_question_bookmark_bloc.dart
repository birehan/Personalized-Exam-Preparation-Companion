import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:prepgenie/features/bookmarks/domain/usecases/delete_bookmarked_question_usecase.dart';

import '../../../../../core/error/failure.dart';

part 'delete_question_bookmark_event.dart';
part 'delete_question_bookmark_state.dart';

class DeleteQuestionBookmarkBloc
    extends Bloc<DeleteQuestionBookmarkEvent, DeleteQuestionBookmarkState> {
  final DeleteQuestionBookmarkUsecase deleteQuestionBookmarkUsecase;
  DeleteQuestionBookmarkBloc({required this.deleteQuestionBookmarkUsecase})
      : super(DeleteQuestionBookmarkInitial()) {
    on<QeustionBookmarkDeletedEvent>(onBookmarkedQuestionDeleted);
  }
  onBookmarkedQuestionDeleted(QeustionBookmarkDeletedEvent event,
      Emitter<DeleteQuestionBookmarkState> emit) async {
    emit(DeleteQuestionBookmarkLoading());
    Either<Failure, void> response = await deleteQuestionBookmarkUsecase(
        DeleteQuestionBookmarkParams(questionId: event.questionId));

    DeleteQuestionBookmarkState state = response.fold(
        (l) => DeleteQuestionBookmarkError(),
        (r) => DeleteQuestionBookmarkSuccessState());
    emit(state);
  }
}
