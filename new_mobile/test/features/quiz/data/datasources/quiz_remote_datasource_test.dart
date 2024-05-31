import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/constants/app_keys.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../repositories/quiz_repository_impl_test.mocks.dart';
import 'quiz_remote_datasource_test.mocks.dart';

abstract class HttpClient implements http.Client {}

@GenerateNiceMocks([
  MockSpec<HttpClient>(),
])
void main() {
  late QuizRemoteDataSource remoteDatasource;
  late MockHttpClient mockHttpClient;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockQuizLocalDatasource mockQuizLocalDatasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockQuizLocalDatasource = MockQuizLocalDatasource();
    remoteDatasource = QuizRemoteDataSourceImpl(
      client: mockHttpClient,
      flutterSecureStorage: mockFlutterSecureStorage,
      localDatasource: mockQuizLocalDatasource,
    );
  });

  const getQuizByCourseId = [
    QuizModel(
      id: '653925700d8e1130915dc3a0',
      courseId: '6530d7be128c1e08e946dee6',
      chapterIds: ['6530de97128c1e08e946defb'],
      userId: '6538f952957a801dfb5e9c52',
      name: 'Micro Organsm Quiz',
      questionIds: ['653241f65f7b64997bfd5de5'],
      score: 0,
      isComplete: false,
    ),
  ];

  const getQuizById = QuizQuestionModel(
      id: '653925700d8e1130915dc3a0',
      name: 'Micro Organsm Quiz',
      userId: '6538f952957a801dfb5e9c52',
      questionAnswers: [
        QuestionAnswerModel(
          question: QuestionModel(
            id: '653241f65f7b64997bfd5de5',
            courseId: '6530d7be128c1e08e946dee6',
            chapterId: '6530de97128c1e08e946defb',
            subChapterId: '6530e4b2128c1e08e946df7e',
            description:
                'Which of the following best describes the structure of HIV?',
            choiceA:
                'A bundle of genetic material surrounded by a protein coat',
            choiceB: 'A single-celled organism with a nucleus',
            choiceC: 'A microscopic animal',
            choiceD: 'A plant-like organism with chlorophyll',
            answer: 'choice_A',
            explanation:
                'HIV is a retrovirus that contains two copies of single-stranded RNA and is surrounded by a protein coat, which fits the description in choice_A. The remaining choices do not correctly describe the structure of HIV.',
            relatedTopic: 'Grade 12 Biology Micro-organisms What are viruses?',
            isForQuiz: true,
            isLiked: true,
          ),
          userAnswer: UserAnswerModel(
            userId: '6538f952957a801dfb5e9c52',
            questionId: '653241f65f7b64997bfd5de5',
            userAnswer: 'choice_E',
          ),
        )
      ]);

  group('getQuizByCourseId', () {
    test('returns a list of quizModel if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
              Uri.parse('$baseUrl/quiz/userQuiz/6530d7be128c1e08e946dee6'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response(fixture('quiz/get_quiz_by_course_id.json'), 200));

      // Testing the methodanyNamed('headers')
      final result =
          await remoteDatasource.getQuizByCourseId('6530d7be128c1e08e946dee6');

      // Assertion
      expect(result, getQuizByCourseId);
      // expect(result, fixture('user_courses.json'));
    });

    test('should throw RequestOverloadException when response code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
              Uri.parse('$baseUrl/quiz/userQuiz/6530d7be128c1e08e946dee6'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));
      final call =
          remoteDatasource.getQuizByCourseId('6530d7be128c1e08e946dee6');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('createQuiz', () {
    test('returns a string if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.post(Uri.parse('$baseUrl/quiz'),
              headers: anyNamed('headers'),
              body: json.encode({
                'name': 'Micro Organsm Quiz',
                'chapters': ['6530de97128c1e08e946defb'],
                'numOfQuestion': 10,
                'courseId': '6530d7be128c1e08e946dee6',
              })))
          .thenAnswer((_) async =>
              http.Response(fixture('quiz/create_quiz.json'), 201));

      // Testing the methodanyNamed('headers')
      final result = await remoteDatasource.createQuiz(
        name: 'Micro Organsm Quiz',
        chapters: ['6530de97128c1e08e946defb'],
        numberOfQuestion: 10,
        courseId: '6530d7be128c1e08e946dee6',
      );

      // Assertion
      expect(result, '6495f8ca595bf811c2eb1356');
      // expect(result, fixture('user_courses.json'));
    });

    test('should throw RequestOverloadException when response code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.post(Uri.parse('$baseUrl/quiz'),
          headers: anyNamed('headers'),
          body: json.encode({
            'name': 'Micro Organsm Quiz',
            'chapters': ['6530de97128c1e08e946defb'],
            'numOfQuestion': 10,
            'courseId': '6530d7be128c1e08e946dee6',
          }))).thenAnswer((_) async => http.Response('Too Many Request', 429));
      final call = remoteDatasource.createQuiz(
          name: 'Micro Organsm Quiz',
          chapters: ['6530de97128c1e08e946defb'],
          numberOfQuestion: 10,
          courseId: '6530d7be128c1e08e946dee6');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('getQuizById', () {
    test('returns a QuizQuestionModel if the http call is successful',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/quiz/6495f8ca595bf811c2eb1356'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(fixture('quiz/get_quiz_by_id.json'), 200));

      // Testing the methodanyNamed('headers')
      final result =
          await remoteDatasource.getQuizById('6495f8ca595bf811c2eb1356');

      // Assertion
      expect(result, getQuizById);
      // expect(result, fixture('user_courses.json'));
    });

    test('should throw RequestOverloadException when response code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/quiz/6495f8ca595bf811c2eb1356'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Too Many Request', 429));
      final call = remoteDatasource.getQuizById('6495f8ca595bf811c2eb1356');
      expect(() async => await call,
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('saveQuizScore', () {
    test('returns a void if the http call is successful', () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/userQuizScore'),
        headers: anyNamed('headers'),
        body: json.encode({
          'quizId': '6495f8ca595bf811c2eb1356',
          'score': 100,
        }),
      )).thenAnswer((_) async => http.Response('true', 201));

      // Testing the methodanyNamed('headers')
      await remoteDatasource.saveQuizScore(
          quizId: '6495f8ca595bf811c2eb1356', score: 100);

      // Assertion
      verify(mockHttpClient.post(
        Uri.parse('$baseUrl/userQuizScore'),
        headers: anyNamed('headers'),
        body: json.encode({
          'quizId': '6495f8ca595bf811c2eb1356',
          'score': 100,
        }),
      )).called(1);
    });

    test('should throw RequestOverloadException when response code is 429',
        () async {
      // Mocking necessary methods and data
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
      final userModelJson = {'token': token};

      when(mockFlutterSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/userQuizScore'),
        headers: anyNamed('headers'),
        body: json.encode({
          'quizId': '6495f8ca595bf811c2eb1356',
          'score': 100,
        }),
      )).thenAnswer((_) async => http.Response('Too Many Request', 429));

      final call =
          remoteDatasource.saveQuizScore(quizId: '6495f8ca595bf811c2eb1356', score: 100);
      
      expect(() async => await call, throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });
}
