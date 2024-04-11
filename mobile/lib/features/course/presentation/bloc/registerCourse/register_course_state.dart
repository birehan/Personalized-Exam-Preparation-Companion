part of 'register_course_bloc.dart';

abstract class RegisterCourseState extends Equatable {
  const RegisterCourseState();

  @override
  List<Object> get props => [];
}

class RegisterCourseInitial extends RegisterCourseState {}

class UserRegisteredState extends RegisterCourseState {}

class CourseRegistrationFailedState extends RegisterCourseState {}

class CourseRegisteringState extends RegisterCourseState {}
