import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/constants/app_keys.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../repositories/course_repository_impl_test.mocks.dart';
import 'course_remote_datasource_test.mocks.dart';

abstract class HttpClient implements http.Client {}

@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late CourseRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;
  late MockCoursesLocalDatasource mockLocalDataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockClient = MockHttpClient();
    mockLocalDataSource = MockCoursesLocalDatasource();
    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = CourseRemoteDataSourceImpl(
      client: mockClient,
      coursesLocalDatasource: mockLocalDataSource,
      flutterSecureStorage: mockSecureStorage,
    );
  });

  const tCourse = Course(
      id: "6530d803128c1e08e946def8",
      cariculumIsNew: false,
      departmentId: "64c24df185876fbb3f8dd6c7",
      description:"This course explores Grade 11 Biology , offering concise subtopic summaries for each chapter. You'll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.",
      ects: "10",
      grade: 11,
      image: CourseImage(imageAddress: "https://res.cloudinary.com/djrfgfo08/image/upload/v1698238074/SkillBridge/k9ajmykrzoihaqrnesgu.png"),
      name: "Biology",
      numberOfChapters: 5,
      referenceBook:"Grade 11 Biology");
  const tUserCourse = [
    UserCourse(
        id: "65c536893a192c185aa9b51b",
        userId: "65c536543a192c185aa9b4ea",
        course: tCourse,
        completedChapters: 1)
  ];

  group('getUserCourses', () {
    test('returns a list of user courses if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
      
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(Uri.parse('$baseUrl/userCourse'), headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('user_course.json'), 200));

      // Testing the methodanyNamed('headers')
      final result = await dataSource.getUserCourses();

      // Assertion
      expect(
        result, tUserCourse
      );
      // expect(result, fixture('user_courses.json'));
    });

  });

}

