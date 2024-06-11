import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:prep_genie/core/constants/app_keys.dart';
import 'package:prep_genie/core/error/exception.dart';
import 'package:prep_genie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../contest/data/datasources/contest_remote_datasources_test.mocks.dart';
import '../repositories/mock_repository_impl_test.mocks.dart';

void main() {
  late MockExamRemoteDatasource remoteDatasource;
  late MockHttpClient mockHttpClient;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockMockExamLocalDatasource mockMockLocalDatasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockMockLocalDatasource = MockMockExamLocalDatasource();
    remoteDatasource = MockExamRemoteDatasourceImpl(
      client: mockHttpClient,
      flutterSecureStorage: mockFlutterSecureStorage,
      localDataSource: mockMockLocalDatasource,
    );
  });

  const getMocks = [
    MockExamModel(
      id: '6538db5f48753d97e4ea2459',
      name: 'Civics Entrance Exam',
      departmentId: '64c24df185876fbb3f8dd6c7',
      examYear: '2013',
      numberOfQuestions: 1,
    ),
  ];

  const getMockById = MockModel(
    id: '6538db5f48753d97e4ea2459',
    name: 'Civics Entrance Exam',
    userId: '6538f952957a801dfb5e9c52',
    mockQuestions: [
      MockQuestionModel(
        question: QuestionModel(
          id: '6538b7b48a99822eeb9e9521',
          courseId: '6530d7be128c1e08e946deef',
          chapterId: '6530de97128c1e08e946df3c',
          subChapterId: '6530e4b2128c1e08e946e082',
          description:
              'Among the agencies of justice, the ones where elders play a vital role are',
          choiceA: 'supreme courts',
          choiceB: 'traditional courts',
          choiceC: 'conventional courts',
          choiceD: 'international courts',
          answer: 'choice_B',
          explanation:
              'The correct answer is choice B, traditional courts. Traditional courts often involve elders who play a vital role in the administration of justice within their communities. Supreme courts, conventional courts, and international courts do not typically have elders playing a significant role.',
          relatedTopic: 'Grade 12 Civics Justice Justice and the Judiciary',
          isForQuiz: false,
          isLiked: false,
        ),
        userAnswer: UserAnswerModel(
          userId: '6538f952957a801dfb5e9c52',
          questionId: '6538b7b48a99822eeb9e9521',
          userAnswer: 'choice_E',
        ),
      ),
    ],
  );

  const getDepartmentMocks = [
    DepartmentMockModel(
      id: 'Chemistry',
      mockExams: [
        MockExamModel(
          id: '64e371ff3e07594c36cda753',
          name: 'Chemistry Enterance Exam | 2022/2024',
          departmentId: '64c24df185876fbb3f8dd6c7',
          examYear: '2022/2023',
          numberOfQuestions: 71,
        )
      ],
    ),
  ];

  const userMocks = [
    UserMockModel(
      id: '65409e4655ae50031e35167b',
      name: 'Mathematics Entrance Exam 2',
      numberOfQuestions: 53,
      departmentId: '64c24df185876fbb3f8dd6c7',
      isCompleted: false,
      score: 0,
    ),
  ];

  group('getMocks', () {
    // test('returns a list of mockExamModel if the http call is successful',
    //     () async {
    //   // Mocking necessary methods and data
    //   const token =
    //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
    //   final userModelJson = {'token': token};

    //   when(mockFlutterSecureStorage.read(key: authenticationKey))
    //       .thenAnswer((_) async => json.encode(userModelJson));

    //   when(mockHttpClient.get(Uri.parse('$baseUrl/mock'),
    //           headers: anyNamed('headers')))
    //       .thenAnswer((_) async =>
    //           http.Response(fixture('mock_exam/get_mocks.json'), 200));

    //   // Testing the methodanyNamed('headers')
    //   final result = await remoteDatasource.getMocks();

    //   // Assertion
    //   // expect(result, getMocks);
    //   expect(result, fixture('mock_exam/get_mocks.json'));
    // });
  });

  group('getMockById', () {
    test('returns a mockModel if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
              Uri.parse(
                  '$baseUrl/mock/6538db5f48753d97e4ea2459?page=0&limit=10'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('mock_exam/get_mock_by_id.json'), 200));

      // Testing the methodanyNamed('headers')
      final result =
          await remoteDatasource.getMockById('6538db5f48753d97e4ea2459', 0);

      // Assertion
      expect(result, getMockById);
      // expect(result, fixture('user_courses.json'));
    });

    test('should throw ReuestOverloadException when the reponse code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
              Uri.parse(
                  '$baseUrl/mock/6538db5f48753d97e4ea2459?page=0&limit=10'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = remoteDatasource.getMockById;

      expect(() async => await call('6538db5f48753d97e4ea2459', 0),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('getDepartmentMocks', () {
    test('returns a list of departmentMockModel if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
              Uri.parse(
                  '$baseUrl/mock/departmentMocks?depId=64c24df185876fbb3f8dd6c7&isStandard=true'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              fixture('mock_exam/get_department_mocks.json'), 200));

      // Testing the methodanyNamed('headers')
      final result = await remoteDatasource.getDepartmentMocks(
          '64c24df185876fbb3f8dd6c7', true);

      // Assertion
      expect(result, getDepartmentMocks);
      // expect(result, fixture('user_courses.json'));
    });

    test('should throw ReuestOverloadException when the reponse code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
              Uri.parse(
                  '$baseUrl/mock/departmentMocks?depId=64c24df185876fbb3f8dd6c7&isStandard=true'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call = remoteDatasource.getDepartmentMocks;
      expect(
          () async => await call('64c24df185876fbb3f8dd6c7',
              true), // Invoke the 'call' function using parentheses
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('upsertMockScore', () {
    test('returns void if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.post(Uri.parse('$baseUrl/userMockScore'),
          headers: anyNamed('headers'),
          body: json.encode({
            'mockId': '64c24df185876fbb3f8dd6c7',
            'score': 100,
          }))).thenAnswer((_) async => http.Response('true', 201));

      // Testing the methodanyNamed('headers')
      await remoteDatasource.upsertMockScore('64c24df185876fbb3f8dd6c7', 100);

      // Assertion
      verify(mockHttpClient.post(Uri.parse('$baseUrl/userMockScore'),
          headers: anyNamed('headers'),
          body: json.encode({
            'mockId': '64c24df185876fbb3f8dd6c7',
            'score': 100,
          }))).called(1);
    });

    test('should throw ReuestOverloadException when the reponse code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.post(Uri.parse('$baseUrl/userMockScore'),
          headers: anyNamed('headers'),
          body: json.encode({
            'mockId': '64c24df185876fbb3f8dd6c7',
            'score': 100,
          }))).thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call =
          remoteDatasource.upsertMockScore('64c24df185876fbb3f8dd6c7', 100);
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('getMyMocks', () {
    test('returns a list of userMockModel if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(Uri.parse('$baseUrl/userMock'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('mock_exam/get_my_mocks.json'), 200));

      // Testing the methodanyNamed('headers')
      final result = await remoteDatasource.getMyMocks();

      // Assertion
      expect(result, userMocks);
    });
  });

  group('addMocktoUserMocks', () {
    test('returns void if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.put(Uri.parse('$baseUrl/userMock/addMock'),
              headers: anyNamed('headers'),
              body: json.encode({'mock': '64c24df185876fbb3f8dd6c7'})))
          .thenAnswer((_) async => http.Response('true', 200));

      // Testing the methodanyNamed('headers')
      await remoteDatasource.addMocktoUserMocks('64c24df185876fbb3f8dd6c7');

      // Assertion
      verify(mockHttpClient.put(Uri.parse('$baseUrl/userMock/addMock'),
          headers: anyNamed('headers'),
          body: json.encode({'mock': '64c24df185876fbb3f8dd6c7'}))).called(1);
    });

    test('should throw ReuestOverloadException when the reponse code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.put(Uri.parse('$baseUrl/userMock/addMock'),
              headers: anyNamed('headers'),
              body: json.encode({'mock': '64c24df185876fbb3f8dd6c7'})))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));
      final call =
          remoteDatasource.addMocktoUserMocks('64c24df185876fbb3f8dd6c7');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('retakeMock', () {
    test('returns void if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.put(
              Uri.parse(
                  '$baseUrl/userMock/retakeMock/64c24df185876fbb3f8dd6c7'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('true', 200));

      // Testing the methodanyNamed('headers')
      await remoteDatasource.retakeMock('64c24df185876fbb3f8dd6c7');

      // Assertion
      verify(mockHttpClient.put(
              Uri.parse(
                  '$baseUrl/userMock/retakeMock/64c24df185876fbb3f8dd6c7'),
              headers: anyNamed('headers')))
          .called(1);
    });

    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.put(
              Uri.parse(
                  '$baseUrl/userMock/retakeMock/64c24df185876fbb3f8dd6c7'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));
      final call = remoteDatasource.retakeMock('64c24df185876fbb3f8dd6c7');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });
}
