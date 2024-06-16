part of 'fetch_course_videos_bloc.dart';

class FetchCourseVideosEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSingleCourseVideosEvent extends FetchCourseVideosEvent {
  FetchSingleCourseVideosEvent({
    required this.courseId,
  });

  final String courseId;

  @override
  List<Object> get props => [courseId];
}

class ChangeVideoStatusLocally extends FetchCourseVideosEvent {
  final int chapterIndex;
  final int subchapterindex;

  ChangeVideoStatusLocally(
      {required this.chapterIndex, required this.subchapterindex});
}
