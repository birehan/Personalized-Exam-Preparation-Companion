import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/domain.dart';

part 'select_course_event.dart';
part 'select_course_state.dart';

class SelectCourseBloc extends Bloc<SelectCourseEvent, SelectCourseState> {
  final GetCoursesByDepartmentIdUseCase getCoursesByDepartmentIdUseCase;
  SelectCourseBloc({required this.getCoursesByDepartmentIdUseCase})
      : super(SelectCourseBlocInitial()) {
    on<GetDepartmentCoursesEvent>(_onGetDepartmentCourses);
  }
  _onGetDepartmentCourses(
      GetDepartmentCoursesEvent event, Emitter<SelectCourseState> emit) async {
    emit(DepartmentCoursesLoadingState());
    final Either<Failure, List<Course>> response =
        await getCoursesByDepartmentIdUseCase(DepartmentIdParams(id: event.id));
    emit(_eitherFailOrCourses(response));
  }

  _eitherFailOrCourses(Either<Failure, List<Course>> eitherOfFailOrCourses) {
    return eitherOfFailOrCourses.fold(
        (failure) =>
            DepartmentCoursesFailedState(message: failure.errorMessage),
        (courses) => DepartmentCoursesLoadedState(courses: courses));
  }
}
