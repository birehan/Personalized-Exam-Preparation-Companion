import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/core/network/network.dart';
import 'package:prepgenie/features/features.dart';

import 'mock_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MockExamRemoteDatasource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<MockExamLocalDatasource>(),
])
void main() {
  late MockMockExamRemoteDatasource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late MockMockExamLocalDatasource localDatasource;
  late MockExamRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockMockExamRemoteDatasource();
    localDatasource = MockMockExamLocalDatasource();
    networkInfo = MockNetworkInfo();

    repositoryImpl = MockExamRepositoryImpl(
      networkInfo: networkInfo,
      localDatasource: localDatasource,
      remoteDatasource: remoteDataSource,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  const tId = "test id";
  const pageNumber = 1;
  const question = QuestionModel(
      isLiked: false,
      id: "653cb1f54535227899808924",
      courseId: "635981f6e40f61599e000064",
      chapterId: "635981f6e40f61599e000064",
      subChapterId: "635981f6e40f61599e000064",
      description:
          "A company uses an arithmetic sequence to determine the salaries of its employees.",
      choiceA: "900,000",
      choiceB: "750,000",
      choiceC: "1,000,000",
      choiceD: "830,000",
      answer: "choice_C",
      explanation: "The sum of an arithmetic series is given by the formula",
      isForQuiz: false);
  const questions = [question];

  const userAnswer = UserAnswerModel(
      userId: "6539339b0d8e1130915dc74d",
      questionId: "653cb1f54535227899808924",
      userAnswer: "choice_E");
  const mockQuestions = [
    MockQuestionModel(question: question, userAnswer: userAnswer)
  ];
  const mockModel = MockModel(
      id: "65409f8955ae50031e35169f",
      name: "SAT Entrance Exam 1",
      userId: "6539339b0d8e1130915dc74d",
      mockQuestions: mockQuestions);
  const mockExams = [
    MockExamModel(
        id: "65409e6055ae50031e35167f",
        name: "English Entrance Exam",
        departmentId: "64c24df185876fbb3f8dd6c7",
        examYear: "2013",
        questions: questions)
  ];

  const departmentMock = [DepartmentMockModel(id: tId, mockExams: mockExams)];

  const userMocks = [
    UserMockModel(
        id: "id",
        name: "name",
        numberOfQuestions: 12,
        departmentId: "departmentId",
        isCompleted: false,
        score: 3)
  ];

  group('getMockById', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getMockById(tId, pageNumber);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getMockById call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getMockById(tId, pageNumber))
            .thenAnswer((_) async => mockModel);
        // act
        final result = await repositoryImpl.getMockById(tId, pageNumber);
        // assert
        verify(remoteDataSource.getMockById(tId, pageNumber));
        expect(result, equals(const Right(mockModel)));
      });

      test(
          'should cache the getMockById when the getMockById call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getMockById(tId, pageNumber))
            .thenAnswer((_) async => mockModel);
        // act
        await repositoryImpl.getMockById(tId, pageNumber);
        // assert
        verify(remoteDataSource.getMockById(tId, pageNumber));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
          () async {
        // act
        final result = await repositoryImpl.getMockById(tId, pageNumber);
        // assert
        verify(networkInfo.isConnected);
        verify(
            localDatasource.getCachedMockExam(id: tId, pageNumer: pageNumber));
        expect(result, Left(NetworkFailure()));
      });

      test("Should return user course form local data source", () async {
        when(localDatasource.getCachedMockExam(id: tId, pageNumer: pageNumber))
            .thenAnswer((_) async => (mockModel));
        final result = await repositoryImpl.getMockById(tId, pageNumber);
        expect(result, const Right(mockModel));
        verify(
            localDatasource.getCachedMockExam(id: tId, pageNumer: pageNumber));
        verifyNoMoreInteractions(localDatasource);
      });
    });
  });

  group('getMocks', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getMocks(isRefreshed: false);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of mock when the getmocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getMocks()).thenAnswer((_) async => mockExams);
        // act
        final result = await repositoryImpl.getMocks(isRefreshed: false);
        // assert
        verify(remoteDataSource.getMocks());
        expect(result, equals(const Right(mockExams)));
      });

      test(
          'should cache the getMocks when the getMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getMocks()).thenAnswer((_) async => mockExams);
        // act
        final result = await repositoryImpl.getMocks(isRefreshed: false);
        // assert
        verify(remoteDataSource.getMocks());
        expect(result, equals(const Right(mockExams)));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
          () async {
        // arrange
        when(remoteDataSource.getMocks()).thenAnswer((_) async => mockExams);
        // act
        final result = await repositoryImpl.getMocks(isRefreshed: false);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('getDepartmentMocks', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getDepartmentMocks(
          departmentId: tId, isRefreshed: false, isStandard: true);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of mock when the getDepartmentMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getDepartmentMocks(tId, true))
            .thenAnswer((_) async => departmentMock);
        // act
        final result = await repositoryImpl.getDepartmentMocks(
            departmentId: tId, isRefreshed: false, isStandard: true);
        // assert
        verify(remoteDataSource.getDepartmentMocks(tId, true));
        expect(result, equals(const Right(departmentMock)));
      });

      test(
          'should cache the getDepartmentMocks when the getDepartmentMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getDepartmentMocks(tId, true))
            .thenAnswer((_) async => departmentMock);
        // act
        final result = await repositoryImpl.getDepartmentMocks(
            departmentId: tId, isRefreshed: false, isStandard: true);
        // assert
        verify(remoteDataSource.getDepartmentMocks(tId, true));
        expect(result, equals(const Right(departmentMock)));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when getDepartmentMocks call to the remote data source is unsuccessful with device connection offline',
          () async {
        // arrange
        when(remoteDataSource.getDepartmentMocks(tId, true))
            .thenAnswer((_) async => departmentMock);
        // act
        final result = await repositoryImpl.getDepartmentMocks(
            departmentId: tId, isRefreshed: false, isStandard: true);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('upsertMockScore', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.upsertMockScore(tId, 3);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of mock when the getDepartmentMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.upsertMockScore(tId, 3))
            .thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.upsertMockScore(tId, 3);
        // assert
        verify(remoteDataSource.upsertMockScore(tId, 3));
        expect(result, equals(const Right(unit)));
      });

      test(
          'should cache the upsertMockScore(tId, 3) when the upsertMockScore(tId, 3) call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.upsertMockScore(tId, 3))
            .thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.upsertMockScore(tId, 3);
        // assert
        verify(remoteDataSource.upsertMockScore(tId, 3));
        expect(result, equals(const Right(unit)));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when upsertMockScore(tId, 3) call to the remote data source is unsuccessful with device connection offline',
          () async {
        // arrange
        when(remoteDataSource.upsertMockScore(tId, 3))
            .thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.upsertMockScore(tId, 3);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('getMyMocks', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getMyMocks(isRefreshed: false);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of mock when the getDepartmentMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getMyMocks()).thenAnswer((_) async => userMocks);
        // act
        final result = await repositoryImpl.getMyMocks(isRefreshed: false);
        // assert
        verify(remoteDataSource.getMyMocks());
        expect(result, equals(const Right(userMocks)));
      });

      test(
          'should cache the upsertMockScore(isRefreshed: false) when the upsertMockScore(isRefreshed: false) call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getMyMocks()).thenAnswer((_) async => userMocks);
        // act
        final result = await repositoryImpl.getMyMocks(isRefreshed: false);
        // assert
        verify(remoteDataSource.getMyMocks());
        expect(result, equals(const Right(userMocks)));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when upsertMockScore(isRefreshed: false) call to the remote data source is unsuccessful with device connection offline',
          () async {
        // arrange
        when(remoteDataSource.getMyMocks()).thenAnswer((_) async => userMocks);
        // act
        final result = await repositoryImpl.getMyMocks(isRefreshed: false);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('addMocktoUserMocks', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.addMocktoUserMocks(tId);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of mock when the getDepartmentMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.addMocktoUserMocks(tId))
            .thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.addMocktoUserMocks(tId);
        // assert
        verify(remoteDataSource.addMocktoUserMocks(tId));
        expect(result, equals(const Right(unit)));
      });

      test(
          'should cache the upsertMockScore(tId) when the upsertMockScore(tId) call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.addMocktoUserMocks(tId))
            .thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.addMocktoUserMocks(tId);
        // assert
        verify(remoteDataSource.addMocktoUserMocks(tId));
        expect(result, equals(const Right(unit)));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when upsertMockScore(tId) call to the remote data source is unsuccessful with device connection offline',
          () async {
        // arrange
        when(remoteDataSource.addMocktoUserMocks(tId))
            .thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.addMocktoUserMocks(tId);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('retakeMock', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.retakeMock(tId);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of mock when the getDepartmentMocks call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.retakeMock(tId)).thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.retakeMock(tId);
        // assert
        verify(remoteDataSource.retakeMock(tId));
        expect(result, equals(const Right(unit)));
      });

      test(
          'should cache the upsertMockScore(tId) when the upsertMockScore(tId) call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.retakeMock(tId)).thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.retakeMock(tId);
        // assert
        verify(remoteDataSource.retakeMock(tId));
        expect(result, equals(const Right(unit)));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when upsertMockScore(tId) call to the remote data source is unsuccessful with device connection offline',
          () async {
        // arrange
        when(remoteDataSource.retakeMock(tId)).thenAnswer((_) async => unit);
        // act
        final result = await repositoryImpl.retakeMock(tId);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });
}
