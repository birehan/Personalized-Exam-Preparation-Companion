import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/constants/app_keys.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../repositories/home_repository_impl_test.mocks.dart';
import 'home_remote_data_source_test.mocks.dart';

abstract class HttpClient implements http.Client {}

@GenerateNiceMocks([
  MockSpec<HttpClient>(),
])
void main() {
  late HomeRemoteDatasource remoteDatasource;
  late MockHomeLocalDatasource mockHomeLocalDatasource;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockHttpClient mockHttpClient;

  const token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';

  final userCredentialString = json.encode(
    {
      'token': token,
    },
  );

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockHomeLocalDatasource = MockHomeLocalDatasource();
    remoteDatasource = HomeRemoteDatasourceImpl(
      client: mockHttpClient,
      flutterSecureStorage: mockFlutterSecureStorage,
      homeLocalDatasource: mockHomeLocalDatasource,
    );

    when(mockFlutterSecureStorage.read(key: authenticationKey))
        .thenAnswer((_) async => userCredentialString);
  });

  final getExamDate = [
    ExamDateModel(
      id: '649be3c293194f83430b3cba',
      date: DateFormat('dd/MM/yyyy').parse('10/7/2023'),
    ),
  ];

  const getMyCourses = [
    UserCourseModel(
      id: '65c63c5dcaff47b59f698dc4',
      userId: '6538f952957a801dfb5e9c52',
      course: CourseModel(
        id: '65a0f2a1938f09b54fca2b11',
        name: 'Physics',
        departmentId: '64c24df185876fbb3f8dd6c7',
        description:
            'This course explores Grade 12 Physics , offering concise subtopic summaries for each chapter. You\'ll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.',
        numberOfChapters: 8,
        ects: '10',
        image: CourseImageModel(
            imageAddress:
                'https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png'),
        grade: 12,
        cariculumIsNew: true,
      ),
      completedChapters: 0,
    ),
  ];

  final fetchDailyStreak = DailyStreakModel(
    userDailyStreaks: [
      UserDailyStreakModel(
        date: DateTime.parse('2024-01-09T00:00:00.000Z'),
        activeOnDay: false,
      ),
    ],
    totalStreak: const TotalStreakModel(
      maxStreak: 0,
      currentStreak: 0,
      points: 0,
    ),
  );

  final fetchDailyQuiz = DailyQuizModel(
    id: '660b658cde5f27e4c2fdb15a',
    departmentId: '64c24df185876fbb3f8dd6c7',
    day: DateTime.tryParse('2024-04-02T00:00:00.000Z'),
    description: 'Complete daily quiz to earn points!',
    dailyQuizQuestions: const [
      DailyQuizQuestionModel(
        id: '65bb4a18f7f7405c3317e6d4',
        description:
            'Choose the alternative that is most appropriate to complete the dialogue.\n\nYou: Are you married, Zahara?\nZahara:________________',
        choiceA: 'Before three years',
        choiceB: 'My husband\'s name is Jemal',
        choiceC: 'I\'m 30',
        choiceD: 'No, I\'m not',
      ),
    ],
    userScore: 0,
    isSolved: false,
  );

  const fetchDailyQuizForAnalysis = DailyQuizModel(
    id: '660b658cde5f27e4c2fdb15a',
    description: 'Complete daily quiz to earn points!',
    userId: '6538f952957a801dfb5e9c52',
    dailyQuizQuestions: [
      DailyQuizQuestionModel(
        id: '65bb4a18f7f7405c3317e6d4',
        description:
            'Choose the alternative that is most appropriate to complete the dialogue.\n\nYou: Are you married, Zahara?\nZahara:________________',
        choiceA: 'Before three years',
        choiceB: 'My husband\'s name is Jemal',
        choiceC: 'I\'m 30',
        choiceD: 'No, I\'m not',
        answer: 'choice_D',
        explanation:
            'The correct answer is choice D, \'No, I\'m not\'. This is an appropriate response to the question about marital status as it indicates being unmarried. Choice A, \'Before three years\', is unrelated to the question and provides a time frame. Choice B, \'My husband\'s name is Jemal\', is unrelated to the question and provides information about a spouse. Choice C, \'I\'m 30\', is unrelated to the question and provides information about age.',
        chapterId: '635981f6e40f61599e000273',
        courseId: '635981f6e40f61599e000273',
        subChapterId: '635981f6e40f61599e000273',
        relatedTopic: 'No Related Topic For Now',
        isLiked: false,
        userId: '6538f952957a801dfb5e9c52',
        userAnswer: 'choice_E',
      ),
    ],
    userScore: 0,
  );

  const fetchDailyQuest = [
    DailyQuestModel(
      challenge: 'Complete Today\'s Daily Quiz',
      expected: 1,
      completed: 1,
    ),
  ];

  group('getExamDate', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/examDate'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(fixture('home/get_exam_date.json'), 200));
      // act
      await remoteDatasource.getExamDate();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/examDate'),
        headers: anyNamed('headers'),
      ));
    });

    test(
        'should return a list of ExamDateModel when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/examDate'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(fixture('home/get_exam_date.json'), 200));
      // act
      final result = await remoteDatasource.getExamDate();
      // assert
      expect(result, equals(getExamDate));
    });

    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/examDate'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.getExamDate;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/examDate'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.getExamDate;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getMyCourses', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(fixture('home/get_my_courses.json'), 200));
      // act
      await remoteDatasource.getMyCourses();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: anyNamed('headers'),
      ));
    });

    test(
        'should return a list of UserCourse when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(fixture('home/get_my_courses.json'), 200));
      // act
      final result = await remoteDatasource.getMyCourses();
      // assert
      expect(result, equals(getMyCourses));
    });

    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.getMyCourses;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.getMyCourses;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchDailyStreak', () {
    final today = DateTime.parse('2024-01-09T00:00:00.000Z');
    final startDate = today.subtract(Duration(days: today.weekday - 1));
    final endDate = today.add(Duration(days: 7 - today.weekday));
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/user/userStreak?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(fixture('home/fetch_daily_streak.json'), 200));
      // act
      await remoteDatasource.fetchDailyStreak(startDate, endDate);
      // assert
      verify(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/user/userStreak?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: anyNamed('headers'),
      ));
    });

    test(
        'should return a DailyStreakModel when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/user/userStreak?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(fixture('home/fetch_daily_streak.json'), 200));
      // act
      final result =
          await remoteDatasource.fetchDailyStreak(startDate, endDate);
      // assert
      expect(result, equals(fetchDailyStreak));
    });

    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/user/userStreak?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.fetchDailyStreak;
      // assert
      expect(() async => await call(startDate, endDate),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/user/userStreak?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchDailyStreak;
      // assert
      expect(() async => await call(startDate, endDate),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchDailyQuiz', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuiz'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(fixture('home/fetch_daily_quiz.json'), 200));
      // act
      await remoteDatasource.fetchDailyQuiz();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuiz'),
        headers: anyNamed('headers'),
      ));
    });

    test(
        'should return a DailyQuizModel when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuiz'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(fixture('home/fetch_daily_quiz.json'), 200));
      // act
      final result = await remoteDatasource.fetchDailyQuiz();
      // assert
      expect(result, equals(fetchDailyQuiz));
    });
    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuiz'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.fetchDailyQuiz;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuiz'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchDailyQuiz;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchDailyQuizForAnalysis', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/dailyQuiz/getDailyQuizAnalysis/660b658cde5f27e4c2fdb15a'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
          fixture('home/fetch_daily_quiz_for_analysis.json'), 200));
      // act
      await remoteDatasource
          .fetchDailyQuizForAnalysis('660b658cde5f27e4c2fdb15a');
      // assert
      verify(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/dailyQuiz/getDailyQuizAnalysis/660b658cde5f27e4c2fdb15a'),
        headers: anyNamed('headers'),
      ));
    });

    test(
        'should return a DailyQuizModel when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/dailyQuiz/getDailyQuizAnalysis/660b658cde5f27e4c2fdb15a'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
          fixture('home/fetch_daily_quiz_for_analysis.json'), 200));
      // act
      final result = await remoteDatasource
          .fetchDailyQuizForAnalysis('660b658cde5f27e4c2fdb15a');
      // assert
      expect(result, equals(fetchDailyQuizForAnalysis));
    });
    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/dailyQuiz/getDailyQuizAnalysis/660b658cde5f27e4c2fdb15a'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.fetchDailyQuizForAnalysis;
      // assert
      expect(() async => await call('660b658cde5f27e4c2fdb15a'),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/dailyQuiz/getDailyQuizAnalysis/660b658cde5f27e4c2fdb15a'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchDailyQuizForAnalysis;
      // assert
      expect(() async => await call('660b658cde5f27e4c2fdb15a'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('submitDailyQuizAnswer', () {
    test(
        'should perform a post request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/dailyQuiz/submitDailyQuizAnswers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('true', 200));
      // act
      await remoteDatasource.submitDailyQuizAnswer(
          const DailyQuizAnswer(dailyQuizId: '', userAnswer: []));
      // assert
      verify(mockHttpClient.post(
        Uri.parse('$baseUrl/dailyQuiz/submitDailyQuizAnswers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ));
    });

    test('should throw ReuestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/dailyQuiz/submitDailyQuizAnswers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.submitDailyQuizAnswer;
      // assert
      expect(
          () async => await call(
              const DailyQuizAnswer(dailyQuizId: '', userAnswer: [])),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/dailyQuiz/submitDailyQuizAnswers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.submitDailyQuizAnswer;
      // assert
      expect(
          () async => await call(
              const DailyQuizAnswer(dailyQuizId: '', userAnswer: [])),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchDailyQuest', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuest/getDailyQuest'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(fixture('home/fetch_daily_quest.json'), 200));
      // act
      await remoteDatasource.fetchDailyQuest();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuest/getDailyQuest'),
        headers: anyNamed('headers'),
      ));
    });

    test(
        'should return a list of DailyQuestModel when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuest/getDailyQuest'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(fixture('home/fetch_daily_quest.json'), 200));
      // act
      final result = await remoteDatasource.fetchDailyQuest();
      // assert
      expect(result, equals(fetchDailyQuest));
    });

    test('should throw RequestOverloadException when the reponse code is 429',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuest/getDailyQuest'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 429));
      // act
      final call = remoteDatasource.fetchDailyQuest;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/dailyQuest/getDailyQuest'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchDailyQuest;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
