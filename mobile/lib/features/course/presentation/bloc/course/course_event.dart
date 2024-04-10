part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class SetCourseEvent extends CourseEvent {
  final Course course;

  const SetCourseEvent({required this.course});

  @override
  List<Object> get props => [course];
}
