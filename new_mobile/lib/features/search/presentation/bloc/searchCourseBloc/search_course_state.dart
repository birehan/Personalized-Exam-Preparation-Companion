part of 'search_course_bloc.dart';

abstract class SearchCourseState extends Equatable {
  const SearchCourseState();

  @override
  List<Object> get props => [];
}

class SearchCourseInitialState extends SearchCourseState {}

class SearchCoursePageNullState extends SearchCourseState {}

class SearchCourseLoadingState extends SearchCourseState {}

class SearchCourseErrorState extends SearchCourseState {
  final Failure failure;
  const SearchCourseErrorState({required this.failure});
}

class SearchCourseLoadedState extends SearchCourseState {
  final List<Course> courses;
  const SearchCourseLoadedState({required this.courses});
}
