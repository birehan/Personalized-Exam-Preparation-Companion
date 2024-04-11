part of 'search_course_bloc.dart';

abstract class SearchCourseEvent extends Equatable {
  const SearchCourseEvent();

  @override
  List<Object> get props => [];
}

class UserSearchCourseEvent extends SearchCourseEvent {
  final String query;
  const UserSearchCourseEvent({required this.query});
}

class SearchPageStartEvent extends SearchCourseEvent {}
