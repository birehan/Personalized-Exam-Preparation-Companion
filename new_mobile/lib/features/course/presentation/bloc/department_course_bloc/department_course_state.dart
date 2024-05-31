part of 'department_course_bloc.dart';

abstract class DepartmentCourseState extends Equatable {
  const DepartmentCourseState();

  @override
  List<Object?> get props => [];
}

class DepartmentCourseInitial extends DepartmentCourseState {}

enum DepartmentCourseStatus { loading, loaded, error }

class GetDepartmentCourseState extends DepartmentCourseState {
  final DepartmentCourseStatus status;
  final DepartmentCourse? departmentCourse;
  final Failure? failure;

  const GetDepartmentCourseState({
    required this.status,
    this.departmentCourse,
    this.failure,
  });

  @override
  List<Object?> get props => [
        status,
        departmentCourse,
      ];
}
