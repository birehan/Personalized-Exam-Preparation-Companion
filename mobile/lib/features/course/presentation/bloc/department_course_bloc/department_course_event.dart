part of 'department_course_bloc.dart';

abstract class DepartmentCourseEvent extends Equatable {
  const DepartmentCourseEvent();

  @override
  List<Object> get props => [];
}

class GetDepartmentCourseEvent extends DepartmentCourseEvent {
  final String id;

  const GetDepartmentCourseEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
