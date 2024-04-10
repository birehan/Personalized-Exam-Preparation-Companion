import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/course/domain/entities/course_image.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'department_course_bloc_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<GetDepartmentCourseUsecase>() 
])

void main() {
  late DepartmentCourseBloc bloc;
  late MockGetDepartmentCourseUsecase mockGetDepartmentCourseUsecase;
  

  setUp(() {
    mockGetDepartmentCourseUsecase = MockGetDepartmentCourseUsecase();
    bloc = DepartmentCourseBloc(getDepartmentCourseUsecase: mockGetDepartmentCourseUsecase);
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

  const departmentCourse = DepartmentCourse(
      biology: tCourse,
      chemistry: tCourse,
      civics: tCourse,
      english: tCourse,
      maths: tCourse,
      physics: tCourse,
      sat: tCourse,
      others: tCourse,
      economics: tCourse,
      history: tCourse,
      geography: tCourse,
      business: tCourse);


  group('_onGetDepartmentCourse', () {
    test('should get data from the fetch course videos usecase', () async {
      // arrange
      when(mockGetDepartmentCourseUsecase(any))
          .thenAnswer((_) async => const Right(departmentCourse));
      // act
      bloc.add(const GetDepartmentCourseEvent(id: tId));

      await untilCalled(mockGetDepartmentCourseUsecase(any));
      // assert
      verify(mockGetDepartmentCourseUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetDepartmentCourseUsecase(any))
          .thenAnswer((_) async => const Right(departmentCourse));
      // assert later
      final expected = [
        const GetDepartmentCourseState(status: DepartmentCourseStatus.loading),
         const GetDepartmentCourseState(status: DepartmentCourseStatus.loaded, departmentCourse: departmentCourse)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentCourseEvent(id: tId));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetDepartmentCourseUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [const GetDepartmentCourseState(status: DepartmentCourseStatus.loading), const GetDepartmentCourseState(status: DepartmentCourseStatus.error)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentCourseEvent(id: tId));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetDepartmentCourseUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [const GetDepartmentCourseState(status: DepartmentCourseStatus.loading), const GetDepartmentCourseState(status: DepartmentCourseStatus.error)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentCourseEvent(id: tId));
    });
  });
}