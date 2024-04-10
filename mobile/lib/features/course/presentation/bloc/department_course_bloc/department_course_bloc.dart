import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';
import '../../../../features.dart';
import '../../../domain/usecases/get_department_course_usecase.dart';

part 'department_course_event.dart';
part 'department_course_state.dart';

class DepartmentCourseBloc
    extends Bloc<DepartmentCourseEvent, DepartmentCourseState> {
  final GetDepartmentCourseUsecase getDepartmentCourseUsecase;

  DepartmentCourseBloc({
    required this.getDepartmentCourseUsecase,
  }) : super(DepartmentCourseInitial()) {
    on<GetDepartmentCourseEvent>(_onGetDepartmentCourse);
  }

  void _onGetDepartmentCourse(GetDepartmentCourseEvent event,
      Emitter<DepartmentCourseState> emit) async {
    emit(
        const GetDepartmentCourseState(status: DepartmentCourseStatus.loading));
    final failureOrDepartmentCourse =
        await getDepartmentCourseUsecase(DepartmentIdParams(id: event.id));
    emit(_departmentCourseOrFailure(failureOrDepartmentCourse));
  }

  GetDepartmentCourseState _departmentCourseOrFailure(
      Either<Failure, DepartmentCourse> failureOrGetDepartmentCourse) {
    return failureOrGetDepartmentCourse.fold(
      (l) =>
          GetDepartmentCourseState(status: DepartmentCourseStatus.error, failure: l),
      (departmentCourse) => GetDepartmentCourseState(
          status: DepartmentCourseStatus.loaded,
          departmentCourse: departmentCourse),
    );
  }
}
