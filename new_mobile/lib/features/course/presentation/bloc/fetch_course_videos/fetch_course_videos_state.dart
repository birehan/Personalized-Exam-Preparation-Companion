part of 'fetch_course_videos_bloc.dart';

class FetchCourseVideosState extends Equatable {
  const FetchCourseVideosState();

  @override
  List<Object> get props => [];
}

class FetchCourseVideosInitial extends FetchCourseVideosState {}

class FetchCourseVideosLoading extends FetchCourseVideosState {}

class FetchCourseVideosLoaded extends FetchCourseVideosState {
  const FetchCourseVideosLoaded({
    required this.chapterVideos,
  });

  final List<ChapterVideo> chapterVideos;

  @override
  List<Object> get props => [chapterVideos];
}

class FetchCourseVideosFailed extends FetchCourseVideosState {
  final String errorMessage;
  final Failure failure;

  const FetchCourseVideosFailed({
    required this.errorMessage,
    required this.failure,
  });


  @override
  List<Object> get props => [errorMessage, failure];
}
