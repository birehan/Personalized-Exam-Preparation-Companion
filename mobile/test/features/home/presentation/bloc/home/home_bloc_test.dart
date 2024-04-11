import 'package:mockito/annotations.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/core/error/error.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';

import 'home_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetMyCoursesUsecase>()])
@GenerateNiceMocks([MockSpec<GetHomeUsecase>()])
void main() {
  late HomeBloc bloc;
  late MockGetMyCoursesUsecase mockGetMyCoursesUsecase;
  late MockGetHomeUsecase mockGetHomeUsecase;

  setUp(() {
    mockGetMyCoursesUsecase = MockGetMyCoursesUsecase();
    mockGetHomeUsecase = MockGetHomeUsecase();
    bloc = HomeBloc(
        getHomeUsecase: mockGetHomeUsecase,
        getMyCoursesUsecase: mockGetMyCoursesUsecase);
  });

  const refresh = true;
  final date = DateTime.now();
  final examDates = [ExamDate(id: "id", date: date)];
  const homeMocks = [
    HomeMock(
        id: "id",
        name: "name",
        departmentId: "departmentId",
        examYear: "examYear",
        subject: "subject",
        numberOfQuestions: 50)
  ];
  const lastStartedChapter = HomeChapter(
      summary: "summary",
      id: "id",
      name: "name",
      description: 'description',
      courseId: "courseId",
      courseName: "courseName",
      noOfSubChapters: 5);
  final homeEntity = HomeEntity(
      lastStartedChapter: lastStartedChapter,
      examDates: examDates,
      homeMocks: homeMocks);
  const course = Course(
      id: "id",
      name: "name",
      departmentId: "departmentId",
      description: "description",
      numberOfChapters: 5,
      ects: "10",
      image: CourseImage(imageAddress: "imageAddress"),
      grade: 10,
      cariculumIsNew: false);
  const userCourses = [
    UserCourse(
        completedChapters: 2, course: course, id: "id", userId: "user id")
  ];

  group('_onGetMyCourses', () {
    test('should get data from the get my courses usecase', () async {
      // arrange
      when(mockGetMyCoursesUsecase(any))
          .thenAnswer((_) async => const Right(userCourses));
      // act
      bloc.add(GetMyCoursesEvent());

      await untilCalled(mockGetMyCoursesUsecase(any));
      // assert
      verify(mockGetMyCoursesUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetMyCoursesUsecase(any))
          .thenAnswer((_) async => const Right(userCourses));
      // assert later
      final expected = [
        const GetMyCoursesState(status: HomeStatus.loading),
        const GetMyCoursesState(
            status: HomeStatus.loaded, userCourses: userCourses)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetMyCoursesEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetMyCoursesUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetMyCoursesState(status: HomeStatus.loading),
        const GetMyCoursesState(status: HomeStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetMyCoursesEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetMyCoursesUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetMyCoursesState(status: HomeStatus.loading),
        const GetMyCoursesState(status: HomeStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetMyCoursesEvent());
    });
  });

  group('_onGetHome', () {
    test('should get data from the get home usecase', () async {
      // arrange
      when(mockGetHomeUsecase(any)).thenAnswer((_) async => Right(homeEntity));
      // act
      bloc.add(const GetHomeEvent(refresh: refresh));

      await untilCalled(mockGetHomeUsecase(any));
      // assert
      verify(mockGetHomeUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetHomeUsecase(any)).thenAnswer((_) async => Right(homeEntity));
      // assert later
      final expected = [
        const GetHomeState(status: HomeStatus.loading),
        GetHomeState(
            status: HomeStatus.loaded,
            examDates: examDates,
            lastStartedChapter: lastStartedChapter,
            recommendedMocks: homeMocks)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetHomeEvent(refresh: refresh));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetHomeUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetHomeState(status: HomeStatus.loading),
        GetHomeState(status: HomeStatus.error, failure: ServerFailure())
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetHomeEvent(refresh: refresh));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetHomeUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetHomeState(status: HomeStatus.loading),
        GetHomeState(status: HomeStatus.error, failure: CacheFailure())
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetHomeEvent(refresh: refresh));
    });
  });
}
