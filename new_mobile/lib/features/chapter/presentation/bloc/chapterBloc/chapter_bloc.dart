import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../../core/error/failure.dart';
import '../../../../features.dart';
import '../../../domain/entities/sub_chapters_entity.dart';

part 'chapter_event.dart';
part 'chapter_state.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final GetSubChaptersListUsecase getSubchaptersListUsecase;
  final GetChapterByCourseIdUsecase getChapterByCourseIdUsecase;

  ChapterBloc({
    required this.getSubchaptersListUsecase,
    required this.getChapterByCourseIdUsecase,
  }) : super(ChapterInitial()) {
    on<GetSubChaptersEvent>(_onGetSubChapter);
    on<GetChapterByCourseIdEvent>(_onGetChapterByCourseId);
  }
  _onGetSubChapter(
      GetSubChaptersEvent event, Emitter<ChapterState> emit) async {
    emit(SubChaptersLoadingState());
    Either<Failure, SubChapters> response =
        await getSubchaptersListUsecase(SubChaptersListParams(id: event.id));
    emit(_eitherFailorSubChapters(response));
  }

  ChapterState _eitherFailorSubChapters(Either<Failure, SubChapters> response) {
    return response.fold(
        (failure) => SubChaptersFailedState(message: failure.errorMessage, failure: failure),
        (chaptersList) => SubChaptersLoadedState(subChapters: chaptersList));
  }

  void _onGetChapterByCourseId(
      GetChapterByCourseIdEvent event, Emitter<ChapterState> emit) async {
    emit(const GetChapterByCourseIdState(status: ChapterStatus.loading));
    final failureOrChapters = await getChapterByCourseIdUsecase(
      GetChapterByCourseIdParams(courseId: event.courseId),
    );
    emit(_chaptersOrFailure(failureOrChapters));
  }

  ChapterState _chaptersOrFailure(
      Either<Failure, List<Chapter>> failureOrChapters) {
    return failureOrChapters.fold(
      (failure) => GetChapterByCourseIdState(
          status: ChapterStatus.error, errorMessage: failure.errorMessage, failure: failure),
      (chapters) => GetChapterByCourseIdState(
        status: ChapterStatus.loaded,
        chapters: chapters,
      ),
    );
  }
}
