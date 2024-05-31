part of 'select_course_bloc.dart';

abstract class SelectCourseEvent extends Equatable {
  const SelectCourseEvent();

  @override
  List<Object> get props => [];
}

class GetDepartmentCoursesEvent extends SelectCourseEvent {
  final String id;

  const GetDepartmentCoursesEvent({required this.id});
}
