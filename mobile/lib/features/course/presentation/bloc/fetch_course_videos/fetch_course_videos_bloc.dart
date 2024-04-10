import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features.dart';

part 'fetch_course_videos_event.dart';
part 'fetch_course_videos_state.dart';

class FetchCourseVideosBloc
    extends Bloc<FetchCourseVideosEvent, FetchCourseVideosState> {
  FetchCourseVideosBloc({
    required this.fetchCourseVideosUsecase,
  }) : super(FetchCourseVideosInitial()) {
    on<FetchCourseVideosEvent>(_onFetchCourseVideos);
  }

  final FetchCourseVideosUsecase fetchCourseVideosUsecase;

  void _onFetchCourseVideos(FetchCourseVideosEvent event,
      Emitter<FetchCourseVideosState> emit) async {
    emit(FetchCourseVideosLoading());

    final failureOrCourseVideos = await fetchCourseVideosUsecase(
      FetchCourseVideoParams(courseId: event.courseId),
    );

    emit(
      failureOrCourseVideos.fold(
        (l) => FetchCourseVideosFailed(errorMessage: l.errorMessage),
        (chapterVideos) =>
            FetchCourseVideosLoaded(chapterVideos: chapterVideos),
      ),
    );
  }
}
