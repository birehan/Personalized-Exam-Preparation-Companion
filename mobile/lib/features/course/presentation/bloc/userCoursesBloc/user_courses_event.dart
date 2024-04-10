part of 'user_courses_bloc.dart';

abstract class UserCoursesEvent extends Equatable {
  const UserCoursesEvent();

  @override
  List<Object> get props => [];
}

class GetUsercoursesEvent extends UserCoursesEvent {
  final bool refresh;

  const GetUsercoursesEvent({required this.refresh});
}
