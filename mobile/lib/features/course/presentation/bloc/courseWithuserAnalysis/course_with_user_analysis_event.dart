part of 'course_with_user_analysis_bloc.dart';

abstract class CourseWithUserAnalysisEvent extends Equatable {
  const CourseWithUserAnalysisEvent();

  @override
  List<Object> get props => [];
}

class GetCourseByIdEvent extends CourseWithUserAnalysisEvent {
  final String id;
  final bool isRefreshed;

  const GetCourseByIdEvent({
    required this.id,
    required this.isRefreshed,
  });

  @override
  List<Object> get props => [id, isRefreshed];
}
