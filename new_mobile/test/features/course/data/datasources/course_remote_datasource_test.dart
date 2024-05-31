import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/constants/app_keys.dart';
import 'package:skill_bridge_mobile/core/error/exception.dart';
import 'package:skill_bridge_mobile/features/chapter/domain/entities/sub_chapters_list.dart';
import 'package:skill_bridge_mobile/features/course/data/models/department_course_model.dart';
import 'package:skill_bridge_mobile/features/course/data/models/user_course_analysis_model.dart';
import 'package:skill_bridge_mobile/features/features.dart';

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

  final tCourse = CourseModel(
    id: "65a0f2a1938f09b54fca2b11",
    isNewCurriculum: true,
    departmentId: "64c24df185876fbb3f8dd6c7",
    description:
        "This course explores Grade 12 Physics , offering concise subtopic summaries for each chapter. You'll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.",
    ects: "10",
    grade: 12,
    image: CourseImageModel(
        imageAddress:
            "https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png"),
    name: "Physics",
    numberOfChapters: 8,
    referenceBook: "Grade 12 Physics",
  );
  const tUserCourse = [
    UserCourseModel(
      id: "65c63c5dcaff47b59f698dc4",
      userId: "6538f952957a801dfb5e9c52",
      course: tCourse,
      completedChapters: 0,
    )
  ];

  const getCourseById = UserCourseAnalysisModel(
    course: CourseModel(
      chapters: [],
      isNewCurriculum: true,
      id: '65a0f2a1938f09b54fca2b11',
      name: 'Physics',
      departmentId: 'Natural Science',
      description:
          'This course explores Grade 12 Physics , offering concise subtopic summaries for each chapter. You\'ll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.',
      numberOfChapters: 8,
      ects: '10',
      image: CourseImageModel(
          imageAddress:
              "https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png"),
      grade: 12,
      cariculumIsNew: true,
    ),
    userChaptersAnalysis: [
      UserChapterAnalysisModel(
        id: '65a0f2a1938f09b54fca2b11',
        chapter: ChapterModel(
          id: '65a0f6a3938f09b54fca2b1c',
          courseId: '65a0f2a1938f09b54fca2b11',
          name: 'Application of physics in other fields',
          description: 'NONE',
          summary: 'NONE',
          noOfSubchapters: 1,
          order: 1,
        ),
        completedSubChapters: 0,
        subchapters: [
          SubChapterList(
            id: '65a0f8ea938f09b54fca2b5c',
            chapterId: '65a0f6a3938f09b54fca2b1c',
            subChapterName: 'Physics and Other Sciences',
            isCompleted: false,
          ),
        ],
      )
    ],
  );

  const getDepartmentCourse = DepartmentCourseModel(
    biology: [
      CourseModel(
        id: '6530d803128c1e08e946def8',
        name: 'Biology',
        departmentId: '64c24df185876fbb3f8dd6c7',
        description:
            'This course explores Grade 11 Biology , offering concise subtopic summaries for each chapter. You\'ll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.',
        numberOfChapters: 5,
        ects: '10',
        image: CourseImageModel(
          imageAddress:
              'https://res.cloudinary.com/djrfgfo08/image/upload/v1698238074/SkillBridge/k9ajmykrzoihaqrnesgu.png',
        ),
        grade: 11,
        cariculumIsNew: true,
      ),
    ],
    chemistry: [],
    civics: [],
    english: [],
    maths: [],
    physics: [],
    sat: [],
    others: [],
    economics: [],
    history: [],
    geography: [],
    business: [],
  );

  const chat = ChatResponseModel(
      messageResponse:
          'A changing magnetic field induces an electric current in a conductor through the process of electromagnetic induction. When there is relative motion between a magnetic field and a conductor, a voltage is induced across the conductor, causing an electric current to flow. This phenomenon is governed by Faraday\'s law of electromagnetic induction.');

  const fetchCourseVideos = [
    ChapterVideoModel(
      title: 'Application of physics in other fields',
      order: 1,
      subchapterVideos: [
        SubchapterVideoModel(
          title: 'Grade 12 Physics Unit 1: Unit Introduction  Part 1',
          videoLink: 'https://www.youtube.com/watch?v=V15jkBeg9B8',
          duration: '1:00:07',
          id: '65e196cad8f0965397904bba',
          courseId: '65a0f2a1938f09b54fca2b11',
          chapterId: '65a0f6a3938f09b54fca2b1c',
          subChapterId: '',
          order: 1,
          thumbnailUrl: 'https://i.ytimg.com/vi/V15jkBeg9B8/default.jpg',
        ),
      ],
      id: '65a0f6a3938f09b54fca2b1c',
      description: 'NONE',
      summary: 'NONE',
      courseId: '65a0f2a1938f09b54fca2b11',
      numberOfSubChapters: 5,
    ),
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

      when(mockClient.get(Uri.parse('$baseUrl/userCourse'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('course/get_user_courses.json'), 200));

      // Testing the methodanyNamed('headers')
      final result = await dataSource.getUserCourses();

      // Assertion
      expect(result, tUserCourse);
      // expect(result, fixture('user_courses.json'));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      )).thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = dataSource.getUserCourses();
      // assert
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('getCourseById', () {
    test('returns a course by id if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(Uri.parse('$baseUrl/course/65a0f2a1938f09b54fca2b11'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('course/get_course_by_id.json'), 200));

      // Testing the methodanyNamed('headers')
      final result = await dataSource.getCourseById('65a0f2a1938f09b54fca2b11');

      // Assertion
      expect(result, getCourseById);
      // expect(result, fixture('user_courses.json'));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(Uri.parse('$baseUrl/course/65a0f2a1938f09b54fca2b11'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = dataSource.getCourseById('65a0f2a1938f09b54fca2b11');
      // assert
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('registercourse', () {
    test('returns true if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.put(Uri.parse('$baseUrl/userCourse/addCourse'),
              headers: anyNamed('headers'),
              body: json.encode({'course': '6530d803128c1e08e946def8'})))
          .thenAnswer((_) async => http.Response('true', 200));

      // Testing the methodanyNamed('headers')
      final result =
          await dataSource.registercourse('6530d803128c1e08e946def8');

      // Assertion
      expect(result, true);
      // expect(result, fixture('user_courses.json'));
    });

    test(
      'should throw a RequestOverloadException when the response code is 429',
      () async {
        const token =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
        final userModelJson = {'token': token};

        when(mockSecureStorage.read(key: authenticationKey))
            .thenAnswer((_) async => json.encode(userModelJson));

        when(mockClient.put(Uri.parse('$baseUrl/userCourse/addCourse'),
                headers: anyNamed('headers'),
                body: json.encode({'course': '6530d803128c1e08e946def8'})))
            .thenAnswer((_) async => http.Response('Too many request', 429));

        final call = dataSource.registercourse('6530d803128c1e08e946def8');
        // assert
        expect(() async => await call,
            throwsA(const TypeMatcher<RequestOverloadException>()));
      },
    );
  });

  group('registerSubChapter', () {
    test('returns true if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.post(
          Uri.parse('$baseUrl/userChapterAnalysis/addSubChapter'),
          headers: anyNamed('headers'),
          body: json.encode({
            'subChapterId': '65a0f8ea938f09b54fca2b5c',
            'chapterId': '65a0f6a3938f09b54fca2b1c'
          }))).thenAnswer((_) async => http.Response('true', 200));

      // Testing the methodanyNamed('headers')
      final result = await dataSource.registerSubChapter(
          '65a0f8ea938f09b54fca2b5c', '65a0f6a3938f09b54fca2b1c');

      // Assertion
      expect(result, true);
      // expect(result, fixture('user_courses.json'));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.post(
              Uri.parse('$baseUrl/userChapterAnalysis/addSubChapter'),
              headers: anyNamed('headers'),
              body: json.encode({
                'subChapterId': '65a0f8ea938f09b54fca2b5c',
                'chapterId': '65a0f6a3938f09b54fca2b1c'
              })))
          .thenAnswer((_) async => http.Response('somethig went wrong', 429));
      final call = dataSource.registerSubChapter(
          '65a0f8ea938f09b54fca2b5c', '65a0f6a3938f09b54fca2b1c');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('getDepartmentCourse', () {
    test('returns a list of department courses if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(
              Uri.parse(
                  '$baseUrl/course/departmentCourses/64c24df185876fbb3f8dd6c7'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('course/get_department_course.json'), 200));

      // Testing the methodanyNamed('headers')
      final result =
          await dataSource.getDepartmentCourse('64c24df185876fbb3f8dd6c7');

      // Assertion
      expect(result, getDepartmentCourse);
      // expect(result, fixture('user_courses.json'));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(
              Uri.parse(
                  '$baseUrl/course/departmentCourses/64c24df185876fbb3f8dd6c7'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = dataSource.getDepartmentCourse('64c24df185876fbb3f8dd6c7');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('chat', () {
    test('returns chat if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(
        mockClient.post(
          Uri.parse('$baseUrl/chat/onContent'),
          body: json.encode(
            {
              'isContest': false,
              'contentId': '',
              'userQuestion': '',
              'chatHistoryObj': [
                [
                  'can you ask me a question based on the content?',
                  "Certainly! Here's a question based on the content you provided:\n\nHow does a changing magnetic field induce an electric current in a conductor?",
                ],
              ],
            },
          ),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
          (_) async => http.Response(fixture('course/chat.json'), 201));

      // Testing the methodanyNamed('headers')
      final result = await dataSource.chat(false, '', '', [
        const ChatHistory(
          human: 'can you ask me a question based on the content?',
          ai: "Certainly! Here's a question based on the content you provided:\n\nHow does a changing magnetic field induce an electric current in a conductor?",
        ),
      ]);

      // Assertion
      expect(result, chat);
      // expect(result, fixture('user_courses.json'));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(
        mockClient.post(
          Uri.parse('$baseUrl/chat/onContent'),
          body: json.encode(
            {
              'isContest': false,
              'contentId': '',
              'userQuestion': '',
              'chatHistoryObj': [
                [
                  'can you ask me a question based on the content?',
                  "Certainly! Here's a question based on the content you provided:\n\nHow does a changing magnetic field induce an electric current in a conductor?",
                ],
              ],
            },
          ),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = dataSource.chat(false, '', '', [
        const ChatHistory(
          human: 'can you ask me a question based on the content?',
          ai: "Certainly! Here's a question based on the content you provided:\n\nHow does a changing magnetic field induce an electric current in a conductor?",
        ),
      ]);
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('fetchCourseVideos', () {
    test('returns a list of chapterVideoModel if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(
              Uri.parse(
                  '$baseUrl/course/video/content/65a0f2a1938f09b54fca2b11'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('course/course_video.json'), 200));

      // Testing the methodanyNamed('headers')
      final result =
          await dataSource.fetchCourseVideos('65a0f2a1938f09b54fca2b11');

      // Assertion
      expect(result, fetchCourseVideos);
      // expect(result, fixture('user_courses.json'));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(
              Uri.parse(
                  '$baseUrl/course/video/content/65a0f2a1938f09b54fca2b11'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = dataSource.fetchCourseVideos('65a0f2a1938f09b54fca2b11');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });
}
