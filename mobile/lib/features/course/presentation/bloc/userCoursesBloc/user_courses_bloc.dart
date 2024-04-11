import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/user_course.dart';
import '../../../domain/usecases/get_user_courses_usecases.dart';

part 'user_courses_event.dart';
part 'user_courses_state.dart';

class UserCoursesBloc extends Bloc<UserCoursesEvent, UserCoursesState> {
  final UserCoursesUseCase userCoursesUsecase;
  UserCoursesBloc({required this.userCoursesUsecase})
      : super(UserCoursesInitial()) {
    on<GetUsercoursesEvent>(getUserCourses);
  }

  getUserCourses(
      GetUsercoursesEvent event, Emitter<UserCoursesState> emit) async {
    emit(UserCoursesLoadingState());
    final Either<Failure, List<UserCourse>> eitherCourseOrFailure =
        await userCoursesUsecase(UserCoursesParams(refresh: event.refresh));
    emit(eitherFailerOrUserCourses(eitherCourseOrFailure));
  }

  UserCoursesState eitherFailerOrUserCourses(
      Either<Failure, List<UserCourse>> eitherCoursesOrFailure) {
    return eitherCoursesOrFailure.fold(
        (failure) => UserCoursesFailedState(
            errorMessage: failure.errorMessage, failure: failure),
        (courses) => UserCoursesLoadedState(courses: courses));
  }
}
