part of 'user_courses_bloc.dart';

abstract class UserCoursesState extends Equatable {
  const UserCoursesState();

  @override
  List<Object> get props => [];
}

class UserCoursesInitial extends UserCoursesState {}

class UserCoursesLoadedState extends UserCoursesState {
  final List<UserCourse> courses;

  const UserCoursesLoadedState({required this.courses});
  @override
  List<Object> get props => [courses];
}

class UserCoursesLoadingState extends UserCoursesState {}

class UserCoursesFailedState extends UserCoursesState {
  final String errorMessage;
  final Failure? failure;

  const UserCoursesFailedState({required this.errorMessage, this.failure});
}
