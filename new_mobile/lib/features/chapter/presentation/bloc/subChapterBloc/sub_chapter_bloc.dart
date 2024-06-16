import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/domain.dart';

import '../../../../../core/error/failure.dart';

part 'sub_chapter_event.dart';
part 'sub_chapter_state.dart';

class SubChapterBloc extends Bloc<SubChapterEvent, SubChapterState> {
  final GetContentOfSubChapterUsecase getContentOfSubChapterUsecase;
  SubChapterBloc({required this.getContentOfSubChapterUsecase})
      : super(SubChapterInitial()) {
    on<GetSubChapterContentsEvent>(_onGetSubChapterContent);
  }
  _onGetSubChapterContent(
      GetSubChapterContentsEvent event, Emitter<SubChapterState> emit) async {
    emit(SubChapterLoadingState());
    final response = await getContentOfSubChapterUsecase(
      GetContentParams(id: event.subChapterId),
    );
    emit(_eitherSubchapterorFailer(response));
  }

  SubChapterState _eitherSubchapterorFailer(
      Either<Failure, SubChapter> response) {
    return response.fold(
        (failure) =>
            SubChapterFailedState(message: failure.errorMessage, failure: failure),
        (subChapter) => SubChapterLoadedState(subChapter: subChapter));
  }
}
