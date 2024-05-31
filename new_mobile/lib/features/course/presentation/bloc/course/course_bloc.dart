import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../course.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<SetCourseEvent>(_setCourse);
  }
  _setCourse(SetCourseEvent event, Emitter<CourseState> emit) {
    emit(CoursePopulatedState(course: event.course));
  }

  CourseState get currentState => state;
}
