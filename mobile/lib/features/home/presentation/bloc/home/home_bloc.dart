import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMyCoursesUsecase getMyCoursesUsecase;
  final GetHomeUsecase getHomeUsecase;

  HomeBloc({
    required this.getMyCoursesUsecase,
    required this.getHomeUsecase,
  }) : super(HomeInitial()) {
    on<GetMyCoursesEvent>(_onGetMyCourses);
    on<GetHomeEvent>(_onGetHome);
  }

  void _onGetMyCourses(GetMyCoursesEvent event, Emitter<HomeState> emit) async {
    emit(const GetMyCoursesState(status: HomeStatus.loading));
    final failureOrMyCourses = await getMyCoursesUsecase(NoParams());
    emit(_onMyCoursesOrFailure(failureOrMyCourses));
  }

  HomeState _onMyCoursesOrFailure(
      Either<Failure, List<UserCourse>> failureOrMyCourses) {
    return failureOrMyCourses.fold(
      (l) => const GetMyCoursesState(status: HomeStatus.error),
      (courses) =>
          GetMyCoursesState(status: HomeStatus.loaded, userCourses: courses),
    );
  }

  void _onGetHome(GetHomeEvent event, Emitter<HomeState> emit) async {
    emit(const GetHomeState(status: HomeStatus.loading));
    final homeContentOrFailure =
        await getHomeUsecase(GetHomeParams(refresh: event.refresh));
    emit(
      homeContentOrFailure.fold(
        (failure) => GetHomeState(status: HomeStatus.error, failure: failure),
        (homeEntity) => GetHomeState(
          status: HomeStatus.loaded,
          examDates: homeEntity.examDates,
          lastStartedChapter: homeEntity.lastStartedChapter,
          recommendedMocks: homeEntity.homeMocks,
        ),
      ),
    );
  }
}
