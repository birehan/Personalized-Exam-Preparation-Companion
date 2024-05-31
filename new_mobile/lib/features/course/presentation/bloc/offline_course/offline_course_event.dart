part of 'offline_course_bloc.dart';

class OfflineCourseEvent extends Equatable {
  const OfflineCourseEvent();

  @override
  List<Object> get props => [];
}

class DownloadCourseByIdEvent extends OfflineCourseEvent {
  const DownloadCourseByIdEvent({
    required this.courseId,
  });

  final String courseId;

  @override
  List<Object> get props => [courseId];
}

class FetchDownloadedCourseEvent extends OfflineCourseEvent {}

class IsCourseDownloadedEvent extends OfflineCourseEvent {
  const IsCourseDownloadedEvent({
    required this.courseId,
  });

  final String courseId;

  @override
  List<Object> get props => [courseId];
}

class MarkCourseAsDownloadedEvent extends OfflineCourseEvent {
  const MarkCourseAsDownloadedEvent({
    required this.courseId,
  });

  final String courseId;

  @override
  List<Object> get props => [courseId];
}
