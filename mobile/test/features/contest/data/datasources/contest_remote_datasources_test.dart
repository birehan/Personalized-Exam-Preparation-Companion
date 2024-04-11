import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/constants/app_keys.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../repositories/contest_repository_impl_test.mocks.dart';
import 'contest_remote_datasources_test.mocks.dart';

abstract class HttpClient implements http.Client {}

@GenerateNiceMocks([
  MockSpec<HttpClient>(),
  MockSpec<FlutterSecureStorage>(),
])
void main() {
  late ContestRemoteDatasource remoteDatasource;
  late MockHttpClient mockHttpClient;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockContestLocalDatasource mockLocalDatasource;

  const token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';

  final headers = {
    'content-type': 'application/json',
    'authorization': 'Bearer $token',
  };

  final userCredentialString = json.encode(
    {
      'token': token,
    },
  );

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockLocalDatasource = MockContestLocalDatasource();
    remoteDatasource = ContestRemoteDatasourceImpl(
      client: mockHttpClient,
      flutterSecureStorage: mockFlutterSecureStorage,
      contestLocalDatasource: mockLocalDatasource,
    );

    when(mockFlutterSecureStorage.read(key: authenticationKey))
        .thenAnswer((_) async => userCredentialString);
  });

  // void setUpMockHttpClientSuccess200() {
  //   when(mockHttpClient.get(
  //     Uri.parse(baseUrl),
  //     headers: anyNamed('headers'),
  //   )).thenAnswer((_) async => http.Response(fixture('contest.json'), 200));
  // }

  // void setUpMockHttpClientSuccess404() {
  //   when(mockHttpClient.get(Uri.parse(baseUrl)))
  //       .thenAnswer((_) async => http.Response('Something went wrong', 404));
  // }

  final contestModel = ContestModel(
    id: '6593b3b08a65e3bd7982fde9',
    title: 'Contest 2',
    description: 'First Contest',
    startsAt: DateTime.parse('2024-01-06T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-06T06:30:00.000Z'),
    createdAt: DateTime.parse('2024-01-02T06:56:48.137Z'),
    live: true,
    hasRegistered: true,
    timeLeft: 120,
    liveRegister: 1,
    virtualRegister: 0,
  );

  final contestModels = [
    ContestModel(
      id: '6593b3b08a65e3bd7982fde9',
      title: 'Contest 2',
      description: 'First Contest',
      startsAt: DateTime.parse('2024-01-06T06:00:00.000Z'),
      endsAt: DateTime.parse('2024-01-06T06:30:00.000Z'),
      createdAt: DateTime.parse('2024-01-02T06:56:48.137Z'),
      live: true,
      hasRegistered: true,
      timeLeft: 120,
      liveRegister: 1,
      virtualRegister: 0,
    ),
  ];

  final previousContest = [
    ContestModel(
      id: '6592786072209a2e5c23a3f8',
      title: 'Contest 1',
      description: '',
      startsAt: DateTime.parse('2024-01-02T06:00:00.000Z'),
      endsAt: DateTime.parse('2024-01-02T06:30:00.000Z'),
      createdAt: DateTime.parse('2024-01-01T08:31:28.489Z'),
      live: false,
      hasRegistered: false,
      timeLeft: 0,
      liveRegister: 0,
      virtualRegister: 0,
    ),
  ];

  final contestById = ContestModel(
    id: '659276d9405be56034f74407',
    title: 'Contest 1',
    description: 'First Contest',
    startsAt: DateTime.parse('2024-01-02T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-02T06:30:00.000Z'),
    createdAt: DateTime.parse('2024-01-01T08:24:57.522Z'),
    live: false,
    hasRegistered: false,
    timeLeft: 0,
    liveRegister: 0,
    virtualRegister: 0,
  );

  final previousUserContest = [
    ContestModel(
      id: '6592786072209a2e5c23a3f8',
      title: 'Contest 1',
      description: '',
      startsAt: DateTime.parse('2024-01-02T06:00:00.000Z'),
      endsAt: DateTime.parse('2024-01-02T06:30:00.000Z'),
      createdAt: DateTime.parse('2024-01-01T08:31:28.489Z'),
      live: false,
      hasRegistered: false,
      timeLeft: 0,
      liveRegister: 0,
      virtualRegister: 0,
    ),
  ];

  final registerToContest = ContestModel(
    id: '6593bbcb5cf174ee61bba660',
    title: '',
    description: '',
    startsAt: DateTime.parse('2024-01-06T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-06T06:30:00.000Z'),
    createdAt: DateTime.parse('2024-01-02T07:31:23.366Z'),
    live: false,
    hasRegistered: false,
    timeLeft: 0,
    liveRegister: 0,
    virtualRegister: 0,
  );
  final contestDetailModel = ContestDetailModel(
    contestId: '659276d9405be56034f74407',
    title: 'Contest 4',
    description: '4th Contest',
    contestType: 'live',
    hasRegistered: false,
    hasEnded: false,
    isLive: false,
    startsAt: DateTime.parse('2024-01-12T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-12T06:30:00.000Z'),
    isUpcoming: true,
    contestCategories: const [
      ContestCategoryModel(
        title: 'Biology Questions',
        subject: 'Biology',
        contestId: '659e4f5d1b78560507eadd9d',
        numberOfQuestion: 2,
        categoryId: '659e5b96f7f62073ac67cf33',
        isSubmitted: false,
        userScore: 0,
      ),
    ],
    contestPrizes: const [
      ContestPrizeModel(
        id: '659e619ad98ed340394305c0',
        description: 'First place Prize',
        standing: 1,
        type: 'cash',
        amount: 500,
      ),
    ],
    timeLeft: 0,
    userRank: 17,
    userScore: 0,
  );

  final getContestRanking = ContestRankModel(
    contestRankEntities: [
      ContestRankingModel(
        id: '65b8b71de23e1a61a61bbbff',
        contestId: '65b7687e6e350b2c0f1754e4',
        startsAt: DateTime.parse('2024-01-30T08:50:45.810Z'),
        endsAt: DateTime.parse('2024-01-30T08:58:14.424Z'),
        score: 14,
        type: 'live',
        userId: '65b20c7a411bc2d6ed31afd8',
        emailOrPhone: '+251987362330',
        firstName: 'Yohannes',
        lastName: 'Ketema',
        department: '64c24df185876fbb3f8dd6c7',
        avatar: defaultProfileAvatar,
      ),
    ],
    userRank: UserRankModel(
      rank: 1,
      contestRankEntity: ContestRankingModel(
        id: '65b8b71de23e1a61a61bbbff',
        contestId: '65b7687e6e350b2c0f1754e4',
        startsAt: DateTime.parse('2024-01-30T08:50:45.810Z'),
        endsAt: DateTime.parse('2024-01-30T08:58:14.424Z'),
        score: 14,
        type: 'live',
        userId: '65b20c7a411bc2d6ed31afd8',
        emailOrPhone: '+251987362330',
        firstName: 'Yohannes',
        lastName: 'Ketema',
        department: '64c24df185876fbb3f8dd6c7',
        avatar: defaultProfileAvatar,
      ),
    ),
  );

  const fetchContestQuestionByCategory = [
    ContestQuestionModel(
      id: '659f7e41f8762555726e12f1',
      courseId: '6530d803128c1e08e946def8',
      description:
          'Which type of bond links the carboxyl group of a fatty acid to the hydroxyl group of a glycerol molecule in a lipid?',
      choiceA: 'Peptide bond',
      choiceB: 'Ester bond',
      choiceC: 'Glycosidic bond',
      choiceD: 'Phosphate bond',
      chapterId: '6530de97128c1e08e946df02',
      contestCategoryId: '659e5b96f7f62073ac67cf33',
      difficulty: 3,
      relatedTopic: 'Grade 11  Enzymes Nature of enzymes',
      subChapterId: '6530e4b2128c1e08e946df98',
      answer: '',
      explanation: '',
      userAnswer: '',
    ),
  ];

  const contestUserAnswer = ContestUserAnswer(
    contestCategoryId: '659e5b96f7f62073ac67cf33',
    userAnswers: [
      ContestAnswer(
        contestQuestionId: '659f7e41f8762555726e12f1',
        userAnswer: 'choice_B',
      ),
    ],
  );
  const fetchContestAnalysisByCategory = [
    ContestQuestionModel(
      id: '659f7e41f8762555726e12f1',
      courseId: '6530d803128c1e08e946def8',
      description:
          'Which type of bond links the carboxyl group of a fatty acid to the hydroxyl group of a glycerol molecule in a lipid?',
      choiceA: 'Peptide bond',
      choiceB: 'Ester bond',
      choiceC: 'Glycosidic bond',
      choiceD: 'Phosphate bond',
      chapterId: '6530de97128c1e08e946df02',
      contestCategoryId: '659e5b96f7f62073ac67cf33',
      difficulty: 3,
      relatedTopic: 'Grade 11  Enzymes Nature of enzymes',
      subChapterId: '6530e4b2128c1e08e946df98',
      answer: 'choice_B',
      explanation:
          'Ester bonds form when the carboxyl group of a fatty acid reacts with the hydroxyl group of a glycerol molecule in a condensation reaction. This forms a triglyceride, a type of lipid. Peptide bonds are found in proteins, glycosidic bonds in carbohydrates and phosphate bonds in nucleic acids and ATP, thus these are not correct.',
      userAnswer: 'choice_E',
    ),
  ];

  group('fetchPreviousContests', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/previousContests'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/upcoming_contest.json'), 200));
      // act
      await remoteDatasource.fetchPreviousContests();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/previousContests'),
        headers: headers,
      ));
    });

    test(
        'should return upcomingContest when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/previousContests'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/fetch_previous_contests.json'), 200));
      // act
      final result = await remoteDatasource.fetchPreviousContests();
      // assert
      expect(result, equals(previousContest));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/previousContests'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchPreviousContests;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchContestById', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/fetch_contest_by_id.json'), 200));
      // act
      await remoteDatasource.fetchContestById(
          contestId: '659276d9405be56034f74407');
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/659276d9405be56034f74407'),
        headers: headers,
      ));
    });

    test(
        'should return upcomingContest when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/fetch_contest_by_id.json'), 200));
      // act
      final result = await remoteDatasource.fetchContestById(
          contestId: '659276d9405be56034f74407');
      // assert
      expect(result, equals(contestById));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchContestById;
      // assert
      expect(() async => await call(contestId: '659276d9405be56034f74407'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchPreviousUserContests', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/userPreviousContests'),
        headers: headers,
      )).thenAnswer((_) async => http.Response(
          fixture('contest/fetch_previous_user_contests.json'), 200));
      // act
      await remoteDatasource.fetchPreviousUserContests();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/userPreviousContests'),
        headers: headers,
      ));
    });

    test(
        'should return upcomingContest when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/userPreviousContests'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/fetch_previous_contests.json'), 200));
      // act
      final result = await remoteDatasource.fetchPreviousUserContests();
      // assert
      expect(result, equals(previousUserContest));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/userPreviousContests'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchPreviousUserContests;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchUpcomingUserContest', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/upcomingContest'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/upcoming_contest.json'), 200));
      // act
      await remoteDatasource.fetchUpcomingUserContest();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/upcomingContest'),
        headers: headers,
      ));
    });

    test(
        'should return upcomingContest when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/upcomingContest'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/upcoming_contest.json'), 200));
      // act
      final result = await remoteDatasource.fetchUpcomingUserContest();
      // assert
      expect(result, equals(contestModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/userContest/upcomingContest'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = await remoteDatasource.fetchUpcomingUserContest;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('registerToContest', () {
    test(
        'should perform a post request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(
        mockHttpClient.post(
          Uri.parse('$baseUrl/contest/userContest'),
          headers: headers,
          body: json.encode(
            {'contestId': '6593b3b08a65e3bd7982fde9'},
          ),
        ),
      ).thenAnswer((_) async =>
          http.Response(fixture('contest/register_to_contest.json'), 201));
      // act
      await remoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockHttpClient.post(
        Uri.parse('$baseUrl/contest/userContest'),
        headers: headers,
        body: json.encode(
          {'contestId': '6593b3b08a65e3bd7982fde9'},
        ),
      ));
    });

    test(
        'should return registerToContest when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/contest/userContest'),
        headers: headers,
        body: json.encode({'contestId': '6593b3b08a65e3bd7982fde9'}),
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/register_to_contest.json'), 201));
      // act
      final result =
          await remoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9');
      // assert
      expect(result, equals(registerToContest));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/contest/userContest'),
        headers: headers,
        body: json.encode({'contestId': '6593b3b08a65e3bd7982fde9'}),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.registerToContest;
      // assert
      expect(() async => await call('6593b3b08a65e3bd7982fde9'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getContestDetail', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestDetail/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/get_contest_detail.json'), 200));
      // act
      await remoteDatasource.getContestDetail('659276d9405be56034f74407');
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestDetail/659276d9405be56034f74407'),
        headers: headers,
      ));
    });

    test(
        'should return getContestDetail when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestDetail/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/get_contest_detail.json'), 200));
      // act
      final result =
          await remoteDatasource.getContestDetail('659276d9405be56034f74407');
      // assert
      expect(result, equals(contestDetailModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestDetail/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.getContestDetail;
      // assert
      expect(() async => await call('659276d9405be56034f74407'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getContestRanking', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestRank/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/get_contest_ranking.json'), 200));
      // act
      await remoteDatasource.getContestRanking('659276d9405be56034f74407');
      // assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestRank/659276d9405be56034f74407'),
        headers: headers,
      ));
    });

    test(
        'should return getContestRanking when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestRank/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async =>
          http.Response(fixture('contest/get_contest_ranking.json'), 200));
      // act
      final result =
          await remoteDatasource.getContestRanking('659276d9405be56034f74407');
      // assert
      expect(result, equals(getContestRanking));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/contest/contestRank/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.getContestRanking;
      // assert
      expect(() async => await call('659276d9405be56034f74407'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchContestQuestionByCategory', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryQuestions/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response(
          fixture('contest/fetch_contest_question_by_category.json'), 200));
      // act
      await remoteDatasource.fetchContestQuestionByCategory(
          categoryId: '659276d9405be56034f74407');
      // assert
      verify(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryQuestions/659276d9405be56034f74407'),
        headers: headers,
      ));
    });

    test(
        'should return fetchContestQuestionByCategory when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryQuestions/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response(
          fixture('contest/fetch_contest_question_by_category.json'), 200));
      // act
      final result = await remoteDatasource.fetchContestQuestionByCategory(
          categoryId: '659276d9405be56034f74407');
      // assert
      expect(result, equals(fetchContestQuestionByCategory));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryQuestions/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchContestQuestionByCategory;
      // assert
      expect(() async => await call(categoryId: '659276d9405be56034f74407'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('submitUserContestAnswer', () {
    test(
        'should perform a post request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      final payload = json.encode(
        {
          'contestCategory': contestUserAnswer.contestCategoryId,
          'userAnswer': contestUserAnswer.userAnswers
              .map(
                (userAnswer) => {
                  'contestQuestionId': userAnswer.contestQuestionId,
                  'userAnswer': userAnswer.userAnswer
                          .substring(0, userAnswer.userAnswer.length - 1) +
                      userAnswer.userAnswer
                          .substring(userAnswer.userAnswer.length - 1)
                          .toUpperCase(),
                },
              )
              .toList(),
        },
      );
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/contest/contestCategory/submitAnswer'),
        headers: headers,
        body: payload,
      )).thenAnswer(
          (_) async => http.Response(json.encode({'success': true}), 200));
      // act
      await remoteDatasource.submitUserContestAnswer(contestUserAnswer);
      // assert
      verify(
        mockHttpClient.post(
          Uri.parse('$baseUrl/contest/contestCategory/submitAnswer'),
          headers: headers,
          body: payload,
        ),
      );
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      final payload = json.encode(
        {
          'contestCategory': contestUserAnswer.contestCategoryId,
          'userAnswer': contestUserAnswer.userAnswers
              .map(
                (userAnswer) => {
                  'contestQuestionId': userAnswer.contestQuestionId,
                  'userAnswer': userAnswer.userAnswer
                          .substring(0, userAnswer.userAnswer.length - 1) +
                      userAnswer.userAnswer
                          .substring(userAnswer.userAnswer.length - 1)
                          .toUpperCase(),
                },
              )
              .toList(),
        },
      );
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/contest/contestCategory/submitAnswer'),
        headers: headers,
        body: payload,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.submitUserContestAnswer;
      // assert
      expect(() async => await call(contestUserAnswer),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('fetchContestAnalysisByCategory', () {
    test(
        'should perform a get request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryAnalysis/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response(
          fixture('contest/fetch_contest_analysis_by_category.json'), 200));
      // act
      await remoteDatasource.fetchContestAnalysisByCategory(
          categoryId: '659276d9405be56034f74407');
      // assert
      verify(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryAnalysis/659276d9405be56034f74407'),
        headers: headers,
      ));
    });

    test(
        'should return fetchContestAnalysisByCategory when the response code is 200 (success)',
        () async {
      // arrange

      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryAnalysis/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response(
          fixture('contest/fetch_contest_analysis_by_category.json'), 200));
      // act
      final result = await remoteDatasource.fetchContestAnalysisByCategory(
          categoryId: '659276d9405be56034f74407');
      // assert
      expect(result, equals(fetchContestAnalysisByCategory));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryAnalysis/659276d9405be56034f74407'),
        headers: headers,
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = remoteDatasource.fetchContestAnalysisByCategory;
      // assert
      expect(() async => await call(categoryId: '659276d9405be56034f74407'),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
