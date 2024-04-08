import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeRemoteDatasource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<HomeLocalDatasource>(),
])
void main() {
  late HomeRepositoryImpl repository;
  late MockHomeLocalDatasource mockLocalDatasource;
  late MockHomeRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockLocalDatasource = MockHomeLocalDatasource();
    mockRemoteDatasource = MockHomeRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    mockFlutterSecureStorage = MockFlutterSecureStorage();

    repository = HomeRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
      flutterSecureStorage: mockFlutterSecureStorage,
    );
  });
  const homeChapter = HomeChapter(
      summary: "summary",
      id: "id",
      name: "name",
      description: "description",
      courseId: "courseId",
      courseName: "courseName",
      noOfSubChapters: 3);
  const fakeHomeModel =
      HomeModel(examDates: [], homeMocks: [], lastStartedChapter: homeChapter);

  final startDate = DateTime.now();
  final endDate = DateTime.now();
  const totalStreak = TotalStreak(maxStreak: 3, currentStreak: 1, points: 4);
  const fakeDailyStreakModel =
      DailyStreakModel(totalStreak: totalStreak, userDailyStreaks: []);
  final fakeDailyQuizModel = DailyQuizModel(
      dailyQuizQuestions: [],
      description: "",
      id: "",
      userScore: 1,
      day: startDate,
      departmentId: "",
      isSolved: false,
      userId: '');

  const List<UserCourse> mockCourses = [
    UserCourseModel(
        id: "id",
        userId: "userId",
        course: Course(
            cariculumIsNew: true,
            departmentId: "",
            description: "",
            ects: "",
            grade: 10,
            id: "",
            image: CourseImageModel(imageAddress: ""),
            name: "",
            numberOfChapters: 2,
            referenceBook: ""),
        completedChapters: 2)
  ];

  const fakeDailyQuizAnswer =
      DailyQuizAnswer(dailyQuizId: "id", userAnswer: []);
  group('getExamDate', () {
    test('should return exam dates from remote when online', () async {
      // Mock network connectivity
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Mock remote data source response
      final List<ExamDateModel> expectedDates = [];
      when(mockRemoteDatasource.getExamDate())
          .thenAnswer((_) async => expectedDates);

      // Call the method
      final result = await repository.getExamDate();

      // Verify the result
      expect(result, Right(expectedDates));
      verify(mockRemoteDatasource.getExamDate());
      verifyZeroInteractions(mockLocalDatasource);
    });
  });

  group('getMyCourses', () {
    test('when device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getMyCourses())
          .thenAnswer((_) async => mockCourses);

      // Act
      final result = await repository.getMyCourses();

      // Assert
      expect(result, equals(Right(mockCourses)));
      verify(mockRemoteDatasource.getMyCourses());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('when device is offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.getMyCourses();

      // Assert
      expect(result, equals(Left(NetworkFailure())));
      verifyZeroInteractions(mockRemoteDatasource);
    });

    test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getMyCourses()).thenThrow(ServerException());

      // Act
      final result = await repository.getMyCourses();

      // Assert
      expect(result, equals(Left(ServerFailure())));
      verify(mockRemoteDatasource.getMyCourses());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test(
        'should return CacheFailure when remote data source throws CacheException',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getMyCourses()).thenThrow(CacheException());

      // Act
      final result = await repository.getMyCourses();

      // Assert
      expect(result, equals(Left(CacheFailure())));
      verify(mockRemoteDatasource.getMyCourses());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('getHomeContent', () {
    test('should return home content when device is online', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getHomeContent())
          .thenAnswer((_) async => fakeHomeModel);

      // Act
      final result = await repository.getHomeContent(false);

      // Assert
      expect(result, const Right(fakeHomeModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDatasource.getHomeContent());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return cached home content when device is offline', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getCachedHomeState())
          .thenAnswer((_) async => fakeHomeModel);

      // Act
      final result = await repository.getHomeContent(false);

      // Assert
      expect(result, Right(fakeHomeModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDatasource.getCachedHomeState());
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test(
        'should return network failure when device is offline and no cached data available',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getCachedHomeState())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getHomeContent(false);

      // Assert
      expect(result, Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDatasource.getCachedHomeState());
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });
  group('fetchDailyStreak', () {
    test('should return daily streak when device is online', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.fetchDailyStreak(startDate, endDate))
          .thenAnswer((_) async => fakeDailyStreakModel);

      // Act
      final result = await repository.fetchDailyStreak(startDate, endDate);

      // Assert
      expect(result, const Right(fakeDailyStreakModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDatasource.fetchDailyStreak(startDate, endDate));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return cached daily streak when device is offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getCachedDailyStreak(startDate, endDate))
          .thenAnswer((_) async => fakeDailyStreakModel);

      // Act
      final result = await repository.fetchDailyStreak(startDate, endDate);

      // Assert
      expect(result, const Right(fakeDailyStreakModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDatasource.getCachedDailyStreak(startDate, endDate));
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test(
        'should return network failure when device is offline and no cached data available',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getCachedDailyStreak(startDate, endDate))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.fetchDailyStreak(startDate, endDate);

      // Assert
      expect(result, Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDatasource.getCachedDailyStreak(startDate, endDate));
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });
  group('fetchDailyQuiz', () {
    test('should return daily quiz when device is online', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.fetchDailyQuiz())
          .thenAnswer((_) async => fakeDailyQuizModel);

      // Act
      final result = await repository.fetchDailyQuiz();

      // Assert
      expect(result, Right(fakeDailyQuizModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDatasource.fetchDailyQuiz());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return cached daily quiz when device is offline', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getCachedDailyQuiz())
          .thenAnswer((_) async => fakeDailyQuizModel);

      // Act
      final result = await repository.fetchDailyQuiz();

      // Assert
      expect(result, Right(fakeDailyQuizModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDatasource.getCachedDailyQuiz());
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test(
        'should return network failure when device is offline and no cached data available',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getCachedDailyQuiz())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.fetchDailyQuiz();

      // Assert
      expect(result, Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDatasource.getCachedDailyQuiz());
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });
  group('fetchDailyQuizForAnalysis', () {
    test('should return daily quiz for analysis when device is online',
        () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.fetchDailyQuizForAnalysis(any))
          .thenAnswer((_) async => fakeDailyQuizModel);

      // Act
      final result = await repository.fetchDailyQuizForAnalysis("id");

      // Assert
      expect(result, Right(fakeDailyQuizModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDatasource.fetchDailyQuizForAnalysis("id"));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return network failure when device is offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.fetchDailyQuizForAnalysis("id");

      // Assert
      expect(result, Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDatasource);
    });
  });
  group('submitDailyQuizAnswer', () {
    test('should submit daily quiz answer when device is online', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      final result =
          await repository.submitDailyQuizAnswer(fakeDailyQuizAnswer);

      // Assert
      expect(result, Right(unit));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDatasource.submitDailyQuizAnswer(fakeDailyQuizAnswer));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return network failure when device is offline', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result =
          await repository.submitDailyQuizAnswer(fakeDailyQuizAnswer);

      // Assert
      expect(result, Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDatasource);
    });
  });
}
