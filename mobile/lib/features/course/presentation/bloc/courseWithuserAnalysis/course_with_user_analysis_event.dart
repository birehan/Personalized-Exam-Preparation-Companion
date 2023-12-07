part of 'course_with_user_analysis_bloc.dart';

abstract class CourseWithUserAnalysisEvent extends Equatable {
  const CourseWithUserAnalysisEvent();

  @override
  List<Object> get props => [];
}

class GetCourseByIdEvent extends CourseWithUserAnalysisEvent {
  final String id;
  const GetCourseByIdEvent({required this.id});
  @override
  List<Object> get props => [id];
}
