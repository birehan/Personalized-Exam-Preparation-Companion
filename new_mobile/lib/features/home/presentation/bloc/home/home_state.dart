part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

enum HomeStatus { loading, loaded, error }

class GetMyCoursesState extends HomeState {
  final HomeStatus status;
  final List<UserCourse>? userCourses;

  const GetMyCoursesState({
    required this.status,
    this.userCourses,
  });

  @override
  List<Object?> get props => [status, userCourses];
}

class GetHomeState extends HomeState {
  const GetHomeState({
    required this.status,
    this.lastStartedChapter,
    this.examDates,
    this.recommendedMocks,
    this.failure,
  });

  final HomeStatus status;
  final HomeChapter? lastStartedChapter;
  final List<ExamDate>? examDates;
  final List<HomeMock>? recommendedMocks;
  final Failure? failure;

  @override
  List<Object?> get props =>
      [status, lastStartedChapter, examDates, recommendedMocks, failure];
}
