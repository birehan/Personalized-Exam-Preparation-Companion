part of 'select_course_bloc.dart';

abstract class SelectCourseState extends Equatable {
  const SelectCourseState();

  @override
  List<Object> get props => [];
}

class SelectCourseBlocInitial extends SelectCourseState {}

class DepartmentCoursesLoadingState extends SelectCourseState {}

class DepartmentCoursesFailedState extends SelectCourseState {
  final String message;

  const DepartmentCoursesFailedState({required this.message});
}

class DepartmentCoursesLoadedState extends SelectCourseState {
  final List<Course> courses;

  const DepartmentCoursesLoadedState({required this.courses});
}
