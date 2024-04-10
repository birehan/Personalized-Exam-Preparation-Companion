part of 'fetch_course_videos_bloc.dart';

class FetchCourseVideosEvent extends Equatable {
  const FetchCourseVideosEvent({required this.courseId,});

  final String courseId;

  @override
  List<Object> get props => [courseId];
}
