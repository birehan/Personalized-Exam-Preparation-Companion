import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/features/course/domain/entities/course_image.dart';
import 'package:prep_genie/features/features.dart';

import 'user_courses_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserCoursesUseCase>()])
void main() {
  late UserCoursesBloc bloc;
  late MockUserCoursesUseCase mockUserCoursesUseCase;

  setUp(() {
    mockUserCoursesUseCase = MockUserCoursesUseCase();
    bloc = UserCoursesBloc(userCoursesUsecase: mockUserCoursesUseCase);
  });

  const tCourse = Course(
      id: "1",
      isNewCurriculum: true,
      departmentId: "dep_id",
      description: "test course description",
      ects: "10",
      grade: 12,
      image: CourseImage(imageAddress: "image address"),
      name: "test course name",
      numberOfChapters: 5,
      referenceBook: "test referance book");
  const tUserCourse = [
    UserCourse(
        id: "test user course id",
        userId: "test user id",
        course: tCourse,
        completedChapters: 1)
  ];

  group('Get User course', () {
    test('should get data from the fetch user courses usecase', () async {
      // arrange
      when(mockUserCoursesUseCase(any))
          .thenAnswer((_) async => const Right(tUserCourse));
      // act
      bloc.add(const GetUsercoursesEvent(refresh: false));

      await untilCalled(mockUserCoursesUseCase(any));
      // assert
      verify(mockUserCoursesUseCase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockUserCoursesUseCase(any))
          .thenAnswer((_) async => const Right(tUserCourse));
      // assert later
      final expected = [
        UserCoursesLoadingState(),
        const UserCoursesLoadedState(courses: tUserCourse)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUsercoursesEvent(refresh: false));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockUserCoursesUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        UserCoursesLoadingState(),
        const UserCoursesFailedState(errorMessage: "Server Faliure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUsercoursesEvent(refresh: false));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockUserCoursesUseCase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        UserCoursesLoadingState(),
        const UserCoursesFailedState(errorMessage: "Cache Faliure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUsercoursesEvent(refresh: false));
    });
  });
}
