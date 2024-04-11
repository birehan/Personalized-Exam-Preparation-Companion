import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import 'search_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchCoursesUsecase>(),
])
void main() {
  late SearchCourseBloc bloc;
  late MockSearchCoursesUsecase mockSearchCoursesUsecase;

  setUp(() {
    mockSearchCoursesUsecase = MockSearchCoursesUsecase();
    bloc = SearchCourseBloc(
      searchCoursesUsecase: mockSearchCoursesUsecase,
    );
  });

  const tCourse = Course(
      id: "1",
      cariculumIsNew: true,
      departmentId: "dep_id",
      description: "test course description",
      ects: "10",
      grade: 12,
      image: CourseImage(imageAddress: "image address"),
      name: "test course name",
      numberOfChapters: 5,
      referenceBook: "test referance book");
  const courses = [tCourse, tCourse, tCourse];

  group('Search courses test', () {
    test('should get data from the search usecase', () async {
      // arrange
      when(mockSearchCoursesUsecase(any))
          .thenAnswer((_) async => const Right(courses));
      // act
      bloc.add(const UserSearchCourseEvent(query: 'course id'));

      await untilCalled(mockSearchCoursesUsecase(any));
      // assert
      verify(mockSearchCoursesUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockSearchCoursesUsecase(any))
          .thenAnswer((_) async => const Right(courses));
      // assert later
      final expected = [
        SearchCourseLoadingState(),
        const SearchCourseLoadedState(courses: courses),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const UserSearchCourseEvent(query: 'course id'));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockSearchCoursesUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        SearchCourseLoadingState(),
        SearchCourseErrorState(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const UserSearchCourseEvent(query: 'course id'));
    });
  });
}
