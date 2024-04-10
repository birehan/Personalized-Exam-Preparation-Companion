part of 'register_course_bloc.dart';

abstract class RegisterCourseEvent extends Equatable {
  const RegisterCourseEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserToACourse extends RegisterCourseEvent {
  final String courseId;

  const RegisterUserToACourse({required this.courseId});
  @override
  List<Object> get props => [courseId];
}
