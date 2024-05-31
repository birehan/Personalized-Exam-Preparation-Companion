import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'search_course_event.dart';
part 'search_course_state.dart';

class SearchCourseBloc extends Bloc<SearchCourseEvent, SearchCourseState> {
  final SearchCoursesUsecase searchCoursesUsecase;
  SearchCourseBloc({required this.searchCoursesUsecase})
      : super(SearchCourseInitialState()) {
    on<SearchPageStartEvent>(onSearchPageStart);
    on<UserSearchCourseEvent>(searchCourse);
  }
  searchCourse(
      UserSearchCourseEvent event, Emitter<SearchCourseState> emit) async {
    emit(SearchCourseLoadingState());
    final Either<Failure, List<Course>> eitherCourseOrFailure =
        await searchCoursesUsecase(SearchCourseQueryParams(query: event.query));
    emit(eitherFailerOrUserCourses(eitherCourseOrFailure));
  }

  SearchCourseState eitherFailerOrUserCourses(
      Either<Failure, List<Course>> eitherCoursesOrFailure) {
    return eitherCoursesOrFailure.fold((failure) => SearchCourseErrorState(failure:failure),
        (courses) => SearchCourseLoadedState(courses: courses));
  }

  void onSearchPageStart(
      SearchPageStartEvent event, Emitter<SearchCourseState> emit) {
    emit(SearchCoursePageNullState());
  }
}
