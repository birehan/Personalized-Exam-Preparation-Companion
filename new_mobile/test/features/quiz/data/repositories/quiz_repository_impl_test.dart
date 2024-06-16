import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';

import 'quiz_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<QuizRemoteDataSource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<QuizLocalDatasource>(),
])
void main() {
  late MockQuizRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late MockQuizLocalDatasource localDatasource;
  late QuizRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockQuizRemoteDataSource();
    localDatasource = MockQuizLocalDatasource();
    networkInfo = MockNetworkInfo();

    repositoryImpl = QuizRepositoryImpl(
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource,
      localDatasource: localDatasource,
    );
  });

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
  const userAnswer = UserAnswerModel(
      userId: "userId", questionId: "questionId", userAnswer: "userAnswer");
  const quizModel = QuizModel(
      id: "65409f8955ae50031e35169f",
      name: "SAT Entrance Exam 1",
      userId: "6539339b0d8e1130915dc74d",
      chapterIds: ["635981f6e40f61599e000064", "635981f6e40f61599e000064"],
      courseId: "6539339b0d8e1130915dc74d",
      score: 5,
      isComplete: true,
      questions: [],
      questionIds: ["653cb1f54535227899808924"]);
  const quizModels = [
    QuizModel(
        id: "65409f8955ae50031e35169f",
        name: "SAT Entrance Exam 1",
        userId: "6539339b0d8e1130915dc74d",
        chapterIds: ["635981f6e40f61599e000064", "635981f6e40f61599e000064"],
        courseId: "6539339b0d8e1130915dc74d",
        score: 5,
        isComplete: true,
        questions: [],
        questionIds: ["653cb1f54535227899808924"]),
  ];

  const questionAnswers = [
    QuestionAnswerModel(question: question, userAnswer: userAnswer)
  ];
  const quizQuestion = QuizQuestionModel(
      id: "id",
      name: "name",
      userId: "userId",
      questionAnswers: questionAnswers);
  const tId = "id";

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

  group('getQuizByCourseId', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getQuizByCourseId(
          courseId: "id", isRefreshed: false);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getQuizByCourseId("id"))
            .thenAnswer((_) async => quizModels);
        // act
        final result = await repositoryImpl.getQuizByCourseId(
            courseId: "id", isRefreshed: false);
        // assert
        verify(remoteDataSource.getQuizByCourseId("id"));
        expect(result, equals(const Right(quizModels)));
      });
    });
  });

  test(
      'should cache the getUserCourse when the getUserCourses call to remote data source is successful',
      () async {
    // arrange
    when(remoteDataSource.getQuizByCourseId("id"))
        .thenAnswer((_) async => [quizModel]);
    // act
    await repositoryImpl.getQuizByCourseId(courseId: "id", isRefreshed: false);
    // assert
    verifyNoMoreInteractions(remoteDataSource);
  });

  runTestOffline(() {
    test(
        'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result = await repositoryImpl.getQuizByCourseId(
          courseId: "id", isRefreshed: false);
      // assert
      verify(networkInfo.isConnected);
      expect(result, Left(NetworkFailure()));
    });
  });

  group('createQuiz', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.createQuiz(
          chapters: ["1", "2"],
          courseId: "id",
          name: "name",
          numberOfQuestion: 5);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.createQuiz(
                chapters: ["1", "2"],
                courseId: "id",
                name: "name",
                numberOfQuestion: 5))
            .thenAnswer((_) async => "responce");
        // act
        final result = await repositoryImpl.createQuiz(
            chapters: ["1", "2"],
            courseId: "id",
            name: "name",
            numberOfQuestion: 5);
        // assert
        verify(remoteDataSource.createQuiz(
            chapters: ["1", "2"],
            courseId: "id",
            name: "name",
            numberOfQuestion: 5));
        expect(result, equals(const Right("responce")));
      });

      test(
          'should cache the getUserCourse when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.createQuiz(
                chapters: ["1", "2"],
                courseId: "id",
                name: "name",
                numberOfQuestion: 5))
            .thenAnswer((_) async => "responce");
        // act
        await repositoryImpl.createQuiz(
            chapters: ["1", "2"],
            courseId: "id",
            name: "name",
            numberOfQuestion: 5);
        // assert
        verify(remoteDataSource.createQuiz(
            chapters: ["1", "2"],
            courseId: "id",
            name: "name",
            numberOfQuestion: 5));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
          () async {
        // act
        final result = await repositoryImpl.createQuiz(
            chapters: ["1", "2"],
            courseId: "id",
            name: "name",
            numberOfQuestion: 5);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('getQuizById', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getQuizById(isRefreshed: false, quizId: "id");
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getQuizById(tId))
            .thenAnswer((_) async => quizQuestion);
        // act
        final result =
            await repositoryImpl.getQuizById(isRefreshed: false, quizId: "id");
        // assert
        verify(remoteDataSource.getQuizById(tId));
        expect(result, equals(const Right(quizQuestion)));
      });

      test(
          'should cache the getUserCourse when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getQuizById(tId))
            .thenAnswer((_) async => quizQuestion);
        // act
        await repositoryImpl.getQuizById(isRefreshed: false, quizId: "id");
        // assert
        verify(remoteDataSource.getQuizById(tId));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
          () async {
        // act
        final result =
            await repositoryImpl.getQuizById(isRefreshed: false, quizId: "id");
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('saveQuizScore', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.saveQuizScore(quizId: tId, score: 5);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.saveQuizScore(quizId: tId, score: 5))
            .thenAnswer((_) async => unit);
        // act
        final result =
            await repositoryImpl.saveQuizScore(quizId: tId, score: 5);
        // assert
        verify(remoteDataSource.saveQuizScore(quizId: tId, score: 5));
        expect(result, equals(const Right(unit)));
      });

      test(
          'should cache the getUserCourse when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.saveQuizScore(quizId: tId, score: 5))
            .thenAnswer((_) async => unit);
        // act
        await repositoryImpl.saveQuizScore(quizId: tId, score: 5);
        // assert
        verify(remoteDataSource.saveQuizScore(quizId: tId, score: 5));
      });
    });
    runTestOffline(() {
      test(
          'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
          () async {
        // act
        final result =
            await repositoryImpl.saveQuizScore(quizId: tId, score: 5);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Left(NetworkFailure()));
      });
    });
  });
}
