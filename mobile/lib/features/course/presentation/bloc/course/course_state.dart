part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoadingState extends CourseState {}

class CoursePopulatedState extends CourseState {
  final Course course;

  const CoursePopulatedState({required this.course});
  @override
  List<Object> get props => [course];
}

class CourseFailedState extends CourseState {
  final String message;

  const CourseFailedState({required this.message});
}
