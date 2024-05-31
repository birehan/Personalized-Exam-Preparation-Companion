import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';

import '../../../../../core/error/failure.dart';

part 'add_content_bookmark_bloc_event.dart';
part 'add_content_bookmark_bloc_state.dart';

class AddContentBookmarkBlocBloc
    extends Bloc<AddContentBookmarkBlocEvent, AddContentBookmarkBlocState> {
  final ContentBookmarkUsecase contentBookmarkUsecase;
  AddContentBookmarkBlocBloc({required this.contentBookmarkUsecase})
      : super(AddContentBookmarkBlocInitial()) {
    on<ContentBookmarkAddedEvent>(_onAddBookmark);
  }
  void _onAddBookmark(ContentBookmarkAddedEvent event,
      Emitter<AddContentBookmarkBlocState> emit) async {
    emit(ContentBookmarkAddingState());
    Either<Failure, bool> response = await contentBookmarkUsecase(
        ContentBookmarkParams(contnetId: event.contentId));
    emit(_eitherFailureOrSuccess(response));
  }

  AddContentBookmarkBlocState _eitherFailureOrSuccess(
      Either<Failure, bool> response) {
    return response.fold(
        (failure) => ContentBookmarkErrorState(failure: failure), (r) => ContentBookmarkAddedState());
  }
}
