import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/domain.dart';

part 'course_with_user_analysis_event.dart';
part 'course_with_user_analysis_state.dart';

class CourseWithUserAnalysisBloc
    extends Bloc<CourseWithUserAnalysisEvent, CourseWithUserAnalysisState> {
  GetCourseWithAnalysisUsecase getCourseUsecase;
  CourseWithUserAnalysisBloc({required this.getCourseUsecase})
      : super(CourseInitialState()) {
    on<GetCourseByIdEvent>(getCourse);
  }

  getCourse(GetCourseByIdEvent event,
      Emitter<CourseWithUserAnalysisState> emit) async {
    emit(CourseLoadingState());
    final Either<Failure, UserCourseAnalysis> eitherCourseOrFailure =
        await getCourseUsecase(CourseIdParams(
      id: event.id,
      isRefreshed: event.isRefreshed,
    ));
    emit(eitherFailerOrUserCourses(eitherCourseOrFailure));
  }

  CourseWithUserAnalysisState eitherFailerOrUserCourses(
      Either<Failure, UserCourseAnalysis> eitherCoursesOrFailure) {
    return eitherCoursesOrFailure.fold(
        (failure) =>
            CourseErrorState(message: failure.errorMessage, failure: failure),
        (course) => CourseLoadedState(userCourseAnalysis: course));
  }
}
