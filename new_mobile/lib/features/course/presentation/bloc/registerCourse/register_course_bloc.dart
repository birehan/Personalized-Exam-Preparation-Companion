import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';
import '../../../domain/usecases/register_course_usercase.dart';

part 'register_course_event.dart';
part 'register_course_state.dart';

class RegisterCourseBloc
    extends Bloc<RegisterCourseEvent, RegisterCourseState> {
  final RegisterCourseUsecase registerCourseUsecase;
  RegisterCourseBloc({required this.registerCourseUsecase})
      : super(RegisterCourseInitial()) {
    on<RegisterUserToACourse>(_onRisterCourse);
  }
  _onRisterCourse(
      RegisterUserToACourse event, Emitter<RegisterCourseState> emit) async {
    print('inside the registering bloc');
    emit(CourseRegisteringState());
    Either<Failure, bool> registered = await registerCourseUsecase(
        RegistrationParams(courseId: event.courseId));
    final state = registered.fold(
      (l) => CourseRegistrationFailedState(),
      (r) => UserRegisteredState(),
    );
    emit(state);
  }
}
