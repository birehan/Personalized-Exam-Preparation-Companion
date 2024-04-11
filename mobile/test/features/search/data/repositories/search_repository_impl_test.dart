import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import '../../domain/usecases/search_courses_usecase_test.mocks.dart';
import 'search_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchCourseRemoteDataSource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late MockSearchCourseRemoteDataSource mockSearchCourseRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late SearchRepositoryImpl searchRepositoryImpl;

  setUp(() {
    mockSearchCourseRemoteDataSource = MockSearchCourseRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    searchRepositoryImpl = SearchRepositoryImpl(
        networkInfo: mockNetworkInfo,
        remoteDataSource: mockSearchCourseRemoteDataSource);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

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

  group('searchcourses', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await searchRepositoryImpl.searchCourses('111');
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user courses when the searchCourses call to remote data source is successful',
          () async {
        // arrange
        when(mockSearchCourseRemoteDataSource.searchCourses("111"))
            .thenAnswer((_) async => courses);
        // act
        final result = await searchRepositoryImpl.searchCourses('111');
        // assert
        verify(mockSearchCourseRemoteDataSource.searchCourses("111"));
        expect(result, const Right(courses));
      });
    });
  });
}
