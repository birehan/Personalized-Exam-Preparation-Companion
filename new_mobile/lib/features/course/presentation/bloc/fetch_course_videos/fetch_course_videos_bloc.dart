import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../features.dart';

part 'fetch_course_videos_event.dart';
part 'fetch_course_videos_state.dart';

class FetchCourseVideosBloc
    extends Bloc<FetchCourseVideosEvent, FetchCourseVideosState> {
  FetchCourseVideosBloc({
    required this.fetchCourseVideosUsecase,
  }) : super(FetchCourseVideosInitial()) {
    on<FetchSingleCourseVideosEvent>(_onFetchCourseVideos);
    on<ChangeVideoStatusLocally>(_videoStatusChanged);
  }

  final FetchCourseVideosUsecase fetchCourseVideosUsecase;

  void _onFetchCourseVideos(FetchSingleCourseVideosEvent event,
      Emitter<FetchCourseVideosState> emit) async {
    emit(FetchCourseVideosLoading());

    final failureOrCourseVideos = await fetchCourseVideosUsecase(
      FetchCourseVideoParams(courseId: event.courseId),
    );

    emit(
      failureOrCourseVideos.fold(
        (failure) => FetchCourseVideosFailed(
            errorMessage: failure.errorMessage, failure: failure),
        (chapterVideos) =>
            FetchCourseVideosLoaded(chapterVideos: chapterVideos),
      ),
    );
  }

  void _videoStatusChanged(
      ChangeVideoStatusLocally event, Emitter<FetchCourseVideosState> emit) {
    if (state is FetchCourseVideosLoaded) {
      final chapterIndex = event.chapterIndex;
      final subChapterIndex = event.subchapterindex;
      final oldChapterVideos = (state as FetchCourseVideosLoaded).chapterVideos;
      final updatedVideo = oldChapterVideos
        ..asMap().forEach((chapterIdx, chapter) {
          if (chapterIdx == chapterIndex) {
            chapter.subchapterVideos
              ..asMap().forEach((subChapterIdx, subChapter) {
                if (subChapterIdx == subChapterIndex) {
                  subChapter.isCompleted = !subChapter.isCompleted;
                }
              });
          }
        });
      emit(FetchCourseVideosLoading()); // temporary implementation
      emit(FetchCourseVideosLoaded(chapterVideos: updatedVideo));
    }
  }
}
