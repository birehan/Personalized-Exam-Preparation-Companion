import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/core/error/error.dart';
import 'package:prep_genie/core/error/exception.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../datasources/contest_remote_datasources_test.mocks.dart';
import 'contest_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ContestRemoteDatasource>(),
  MockSpec<ContestLocalDatasource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockContestLocalDatasource mockLocalDatasource;
  late MockContestRemoteDatasource mockRemoteDatasource;
  late ContestRepositoryImpl repositoryImpl;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDatasource = MockContestLocalDatasource();
    mockRemoteDatasource = MockContestRemoteDatasource();
    repositoryImpl = ContestRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  Map<String, dynamic> contestJsonMap = {
    "data": {
      "contests": [
        {
          "_id": "659276d9405be56034f74407",
          "description": "First Contest",
          "title": "Contest 1",
          "startsAt": "2024-01-02T06:00:00.000Z",
          "endsAt": "2024-01-02T06:30:00.000Z",
          "createdAt": "2024-01-01T08:24:57.522Z",
          "updatedAt": "2024-01-01T08:24:57.522Z",
          "__v": 0
        }
      ]
    },
    "success": true,
    "message": "Contests retrieved successfully!",
    "errors": [null]
  };

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

  final contestDetailModel = ContestDetailModel(
    contestId: '659e4f5d1b78560507eadd9d',
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

  const contestQuestion = [
    ContestQuestionModel(
      id: '659f7e41f8762555726e12f1',
      contestCategoryId: '659e5b96f7f62073ac67cf33',
      chapterId: '6530de97128c1e08e946df02',
      courseId: '6530d803128c1e08e946def8',
      subChapterId: '6530e4b2128c1e08e946df98',
      description:
          'Which type of bond links the carboxyl group of a fatty acid to the hydroxyl group of a glycerol molecule in a lipid?',
      choiceA: 'Peptide bond',
      choiceB: 'Ester bond',
      choiceC: 'Glycosidic bond',
      choiceD: 'Phosphate bond',
      relatedTopic: 'Grade 11  Enzymes Nature of enzymes',
      difficulty: 3,
      answer: '',
      explanation: '',
      userAnswer: '',
    ),
  ];

  final contestRankModel = ContestRankModel(
    contestRankEntities: [
      ContestRankingModel(
        rank: 1,
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
        rank: 1,
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

  const contestUserAnswer = ContestUserAnswer(
    contestCategoryId: '659e5b96f7f62073ac67cf33',
    userAnswers: [
      ContestAnswer(
        contestQuestionId: '659f7e41f8762555726e12f1',
        userAnswer: 'choice_B',
      ),
    ],
  );

  group('fetch previous contests', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchPreviousContests();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return previousContest when the fetchPreviousContests call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchPreviousContests())
            .thenAnswer((_) async => contestModels);
        // act
        final result = await repositoryImpl.fetchPreviousContests();
        // assert
        verify(mockRemoteDatasource.fetchPreviousContests());
        expect(result, equals(Right(contestModels)));
      });

      // test(
      //     'should cache the contestModels when the fetchPreviousContest call to remote data source is successful',
      //     () async {
      //   // arrange
      //   when(mockRemoteDatasource.fetchPreviousContests())
      //       .thenAnswer((_) async => contestModels);
      //   // act
      //   await repositoryImpl.fetchPreviousContests();
      //   // assert
      //   verify(mockRemoteDatasource.fetchPreviousContests());
      //   verify(mockLocalDatasource
      //       .cachePreviousContests(contestJsonMap.toString()));
      // });
      test(
          'should return Request over load failure when the fetchPreviousContests call to remote data has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchPreviousContests())
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl.fetchPreviousContests();
        // assert
        verify(mockRemoteDatasource.fetchPreviousContests());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the fetchPreviousContests call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchPreviousContests())
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.fetchPreviousContests();
        // assert
        verify(mockRemoteDatasource.fetchPreviousContests());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when fetchPreviousContests call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl.fetchPreviousContests();
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });

      test(
          'should not cache previousContest when fetchPreviousContests call to remote data source is unsuccessful with device connection',
          () async {
        // act
        await repositoryImpl.fetchPreviousContests();
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockLocalDatasource
            .cachePreviousContests(contestJsonMap.toString()));
      });
    });
  });

  group('fetch contest by id', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchContestById(
          contestId: '6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return previousContest when the fetchContestById call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestById(
                contestId: '6593b3b08a65e3bd7982fde9'))
            .thenAnswer((_) async => contestModel);
        // act
        final result = await repositoryImpl.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9'));
        expect(result, equals(Right(contestModel)));
      });

      test(
          'should return request over load failure when the fetchContestById call to remote data source has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestById(
                contestId: '6593b3b08a65e3bd7982fde9'))
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the fetchContestById call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestById(
                contestId: '6593b3b08a65e3bd7982fde9'))
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when fetchContestById call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('fetch previous user contest', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchPreviousUserContests();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return previousContest when the fetchPreviousUserContests call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchPreviousUserContests())
            .thenAnswer((_) async => contestModels);
        // act
        final result = await repositoryImpl.fetchPreviousUserContests();
        // assert
        verify(mockRemoteDatasource.fetchPreviousUserContests());
        expect(result, equals(Right(contestModels)));
      });
      test(
          'should return request over load failure when the fetchPreviousUserContests call to remote data source has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchPreviousUserContests())
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl.fetchPreviousUserContests();
        // assert
        verify(mockRemoteDatasource.fetchPreviousUserContests());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the fetchPreviousUserContests call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchPreviousUserContests())
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.fetchPreviousUserContests();
        // assert
        verify(mockRemoteDatasource.fetchPreviousUserContests());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when fetchPreviousUserContests call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl.fetchPreviousUserContests();
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('fetch upcoming user contest', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchUpcomingUserContest();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return upcomingUserContestModel when the fetchUpcomingUserContest call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchUpcomingUserContest())
            .thenAnswer((_) async => contestModel);
        // act
        final result = await repositoryImpl.fetchUpcomingUserContest();
        // assert
        verify(mockRemoteDatasource.fetchUpcomingUserContest());
        expect(result, equals(Right(contestModel)));
      });

      // test('should cache the contestModel when the fetchUpcomingUserContest call to remote data source is successful', () async {
      //   // arrange
      //   when(mockRemoteDatasource.fetchUpcomingUserContest()).thenAnswer((_) async => contestModel );
      //   // act
      //   await repositoryImpl.fetchUpcomingUserContest();
      //   // assert
      //   verify(mockRemoteDatasource.fetchUpcomingUserContest());
      //   verify(mockLocalDatasource.);
      // });
      test(
          'should return request over load failure when the fetchUpcomingUserContest call to remote data source has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchUpcomingUserContest())
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl.fetchUpcomingUserContest();
        // assert
        verify(mockRemoteDatasource.fetchUpcomingUserContest());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the fetchUpcomingUserContest call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchUpcomingUserContest())
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.fetchUpcomingUserContest();
        // assert
        verify(mockRemoteDatasource.fetchUpcomingUserContest());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when fetchUpcomingUserContest call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl.fetchUpcomingUserContest();
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockLocalDatasource);
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('register to contest', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.registerUserToContest('6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return contestModel when the registerToContest call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9'))
            .thenAnswer((_) async => contestModel);
        // act
        final result = await repositoryImpl
            .registerUserToContest('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9'));
        expect(result, equals(Right(contestModel)));
      });
      test(
          'should return request over load failure when the registerToContest call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9'))
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl
            .registerUserToContest('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the registerToContest call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9'))
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl
            .registerUserToContest('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.registerToContest('6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when registerToContest call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl
            .registerUserToContest('6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('get contest detail', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getContestDetail('6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return contestDetail when the getContestDetail call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.getContestDetail('6593b3b08a65e3bd7982fde9'))
            .thenAnswer((_) async => contestDetailModel);
        // act
        final result =
            await repositoryImpl.getContestDetail('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.getContestDetail('6593b3b08a65e3bd7982fde9'));
        expect(result, equals(Right(contestDetailModel)));
      });

      test(
          'should return server failure when the getContestDetail call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.getContestDetail('6593b3b08a65e3bd7982fde9'))
            .thenThrow(ServerException());
        // act
        final result =
            await repositoryImpl.getContestDetail('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.getContestDetail('6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when getContestDetail call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result =
            await repositoryImpl.getContestDetail('6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('fetch contest question by category', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchContestQuestionsByCategory(
          categoryId: '6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return contestQuestion when the fetchContestQuestionByCategory call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestQuestionByCategory(
                categoryId: '6593b3b08a65e3bd7982fde9'))
            .thenAnswer((_) async => contestQuestion);
        // act
        final result = await repositoryImpl.fetchContestQuestionsByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestQuestionByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9'));
        expect(result, equals(const Right(contestQuestion)));
      });

      test(
          'should return request over load failure when the fetchContestQuestionByCategory call to remote data source has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestQuestionByCategory(
                categoryId: '6593b3b08a65e3bd7982fde9'))
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl.fetchContestQuestionsByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestQuestionByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the fetchContestQuestionByCategory call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestQuestionByCategory(
                categoryId: '6593b3b08a65e3bd7982fde9'))
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.fetchContestQuestionsByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestQuestionByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when fetchContestQuestionByCategory call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl.fetchContestQuestionsByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('submit user contest answer', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.submitUserContestAnswer(contestUserAnswer);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return void(unit) when the submitUserContestAnswer call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.submitUserContestAnswer(contestUserAnswer))
            .thenAnswer((_) async => unit);
        // act
        final result =
            await repositoryImpl.submitUserContestAnswer(contestUserAnswer);
        // assert
        verify(mockRemoteDatasource.submitUserContestAnswer(contestUserAnswer));
        expect(result, equals(const Right(unit)));
      });
      test(
          'should return request over load failure when the submitUserContestAnswer call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.submitUserContestAnswer(contestUserAnswer))
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result =
            await repositoryImpl.submitUserContestAnswer(contestUserAnswer);
        // assert
        verify(mockRemoteDatasource.submitUserContestAnswer(contestUserAnswer));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the submitUserContestAnswer call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.submitUserContestAnswer(contestUserAnswer))
            .thenThrow(ServerException());
        // act
        final result =
            await repositoryImpl.submitUserContestAnswer(contestUserAnswer);
        // assert
        verify(mockRemoteDatasource.submitUserContestAnswer(contestUserAnswer));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when submitUserContestAnswer call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result =
            await repositoryImpl.submitUserContestAnswer(contestUserAnswer);
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('get contest ranking', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getContestRanking('6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return contestRankingModel when the getContestRanking call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.getContestRanking('6593b3b08a65e3bd7982fde9'))
            .thenAnswer((_) async => contestRankModel);
        // act
        final result =
            await repositoryImpl.getContestRanking('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.getContestRanking('6593b3b08a65e3bd7982fde9'));
        expect(result, equals(Right(contestRankModel)));
      });
      test(
          'should return request over load failure when the getContestRanking call to remote data source has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.getContestRanking('6593b3b08a65e3bd7982fde9'))
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result =
            await repositoryImpl.getContestRanking('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.getContestRanking('6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the getContestRanking call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.getContestRanking('6593b3b08a65e3bd7982fde9'))
            .thenThrow(ServerException());
        // act
        final result =
            await repositoryImpl.getContestRanking('6593b3b08a65e3bd7982fde9');
        // assert
        verify(
            mockRemoteDatasource.getContestRanking('6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when getContestRanking call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result =
            await repositoryImpl.getContestRanking('6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('fetch contest analysis by category', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchContestAnalysisByCategory(
          categoryId: '6593b3b08a65e3bd7982fde9');
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return contestQuestion when the fetchContestAnalysisByCategory call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestAnalysisByCategory(
                categoryId: '6593b3b08a65e3bd7982fde9'))
            .thenAnswer((_) async => contestQuestion);
        // act
        final result = await repositoryImpl.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9'));
        expect(result, equals(const Right(contestQuestion)));
      });
      test(
          'should return request over load failure when the fetchContestAnalysisByCategory call to remote data source has many request',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestAnalysisByCategory(
                categoryId: '6593b3b08a65e3bd7982fde9'))
            .thenThrow(RequestOverloadException(errorMessage: ''));
        // act
        final result = await repositoryImpl.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(RequestOverloadFailure(errorMessage: ''))));
      });
      test(
          'should return server failure when the fetchContestAnalysisByCategory call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDatasource.fetchContestAnalysisByCategory(
                categoryId: '6593b3b08a65e3bd7982fde9'))
            .thenThrow(ServerException());
        // act
        final result = await repositoryImpl.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockRemoteDatasource.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9'));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return network connection failure when fetchContestAnalysisByCategory call to remote data source is unsuccessful with device connection',
          () async {
        // act
        final result = await repositoryImpl.fetchContestAnalysisByCategory(
            categoryId: '6593b3b08a65e3bd7982fde9');
        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });
}
