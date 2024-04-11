import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import 'select_course_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetCoursesByDepartmentIdUseCase>()])
void main() {
  late SelectCourseBloc bloc;
  late MockGetCoursesByDepartmentIdUseCase mockCourseByDepartmentIdUseCase;

  setUp(() {
    mockCourseByDepartmentIdUseCase = MockGetCoursesByDepartmentIdUseCase();
    bloc = SelectCourseBloc(
        getCoursesByDepartmentIdUseCase: mockCourseByDepartmentIdUseCase);
  });

  const tId = "test id";
  const tCourse = [
    Course(
        id: "1",
        cariculumIsNew: true,
        departmentId: "dep_id",
        description: "test course description",
        ects: "10",
        grade: 12,
        image: CourseImage(imageAddress: "image address"),
        name: "test course name",
        numberOfChapters: 5,
        referenceBook: "test referance book")
  ];

  group('Select course', () {
    test('should get data from the fetch get course by department Id usecase',
        () async {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => const Right(tCourse));
      // act
      bloc.add(const GetDepartmentCoursesEvent(id: tId));

      await untilCalled(mockCourseByDepartmentIdUseCase(any));
      // assert
      verify(mockCourseByDepartmentIdUseCase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => const Right(tCourse));
      // assert later
      final expected = [
        DepartmentCoursesLoadingState(),
        const DepartmentCoursesLoadedState(courses: tCourse)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentCoursesEvent(id: tId));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        DepartmentCoursesLoadingState(),
        const DepartmentCoursesFailedState(message: "Server Faliure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentCoursesEvent(id: tId));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        DepartmentCoursesLoadingState(),
        const DepartmentCoursesFailedState(message: "Server Faliure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentCoursesEvent(id: tId));
    });
  });
}
