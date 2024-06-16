part of 'offline_course_bloc.dart';

class OfflineCourseState extends Equatable {
  const OfflineCourseState();

  @override
  List<Object> get props => [];
}

class OfflineCourseInitial extends OfflineCourseState {}

class DownloadCourseByIdLoading extends OfflineCourseState {}

class DownloadCourseByIdLoaded extends OfflineCourseState {}

class DownloadCourseByIdFailed extends OfflineCourseState {
  const DownloadCourseByIdFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class FetchDownloadedCoursesLoading extends OfflineCourseState {}

class FetchDownloadedCoursesLoaded extends OfflineCourseState {
  const FetchDownloadedCoursesLoaded({
    required this.courses,
  });

  final List<Course> courses;

  @override
  List<Object> get props => [courses];
}

class FetchDownloadedCoursesFailed extends OfflineCourseState {
  const FetchDownloadedCoursesFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class IsCourseDownloadedLoading extends OfflineCourseState {}

class IsCourseDownloadedLoaded extends OfflineCourseState {
  const IsCourseDownloadedLoaded({
    required this.isCourseDownloaded,
  });

  final bool isCourseDownloaded;

  @override
  List<Object> get props => [isCourseDownloaded];
}

class IsCourseDownloadedFailed extends OfflineCourseState {
  const IsCourseDownloadedFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class MarkCourseAsDownloadedLoading extends OfflineCourseState {}

class MarkCourseAsDownloadedLoaded extends OfflineCourseState {
}

class MarkCourseAsDownloadedFailed extends OfflineCourseState {
  const MarkCourseAsDownloadedFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
