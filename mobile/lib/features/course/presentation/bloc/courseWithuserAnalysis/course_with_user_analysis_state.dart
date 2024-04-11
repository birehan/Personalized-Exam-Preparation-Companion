part of 'course_with_user_analysis_bloc.dart';

abstract class CourseWithUserAnalysisState extends Equatable {
  const CourseWithUserAnalysisState();

  @override
  List<Object> get props => [];
}

class CourseInitialState extends CourseWithUserAnalysisState {}

class CourseLoadingState extends CourseWithUserAnalysisState {}

class CourseLoadedState extends CourseWithUserAnalysisState {
  final UserCourseAnalysis userCourseAnalysis;
  const CourseLoadedState({required this.userCourseAnalysis});
}

class CourseErrorState extends CourseWithUserAnalysisState {
  final String message;
  final Failure failure;
  const CourseErrorState({required this.message, required this.failure});
}
