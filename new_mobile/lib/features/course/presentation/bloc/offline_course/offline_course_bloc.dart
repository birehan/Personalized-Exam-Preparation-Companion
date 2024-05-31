import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/course/course.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'offline_course_event.dart';
part 'offline_course_state.dart';

class OfflineCourseBloc extends Bloc<OfflineCourseEvent, OfflineCourseState> {
  OfflineCourseBloc({
    required this.downloadCourseByIdUsecase,
    required this.fetchDownloadedCoursesUsecase,
    required this.isCourseDownloadedUsecase,
    required this.markCourseAsDownloadedUsecase,
  }) : super(OfflineCourseInitial()) {
    on<DownloadCourseByIdEvent>((event, emit) async {
      emit(DownloadCourseByIdLoading());
      final failureOrSuccess = await downloadCourseByIdUsecase(
          DownloadCourseByIdParams(courseId: event.courseId));
      emit(
        failureOrSuccess.fold(
          (l) => DownloadCourseByIdFailed(failure: l),
          (r) => DownloadCourseByIdLoaded(),
        ),
      );
    });
    on<FetchDownloadedCourseEvent>((event, emit) async {
      emit(FetchDownloadedCoursesLoading());
      final failureOrSuccess = await fetchDownloadedCoursesUsecase(NoParams());
      emit(
        failureOrSuccess.fold(
          (l) => FetchDownloadedCoursesFailed(failure: l),
          (courses) => FetchDownloadedCoursesLoaded(courses: courses),
        ),
      );
    });
    on<IsCourseDownloadedEvent>((event, emit) async {
      emit(IsCourseDownloadedLoading());
      final failureOrSuccess = await isCourseDownloadedUsecase(
          IsCourseDownloadedParams(courseId: event.courseId));
      emit(
        failureOrSuccess.fold(
          (l) => IsCourseDownloadedFailed(failure: l),
          (isCourseDownloaded) =>
              IsCourseDownloadedLoaded(isCourseDownloaded: isCourseDownloaded),
        ),
      );
    });
    on<MarkCourseAsDownloadedEvent>((event, emit) async {
      emit(MarkCourseAsDownloadedLoading());
      final failureOrSuccess = await markCourseAsDownloadedUsecase(
          MarkCourseAsDownloadedParams(courseId: event.courseId));
      emit(
        failureOrSuccess.fold(
          (l) => MarkCourseAsDownloadedFailed(failure: l),
          (_) => MarkCourseAsDownloadedLoaded(),
        ),
      );
    });
  }

  final DownloadCourseByIdUsecase downloadCourseByIdUsecase;
  final FetchDownloadedCoursesUsecase fetchDownloadedCoursesUsecase;
  final IsCourseDownloadedUsecase isCourseDownloadedUsecase;
  final MarkCourseAsDownloadedUsecase markCourseAsDownloadedUsecase;
}
