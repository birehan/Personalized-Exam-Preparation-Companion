import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/core/network/network.dart';
import 'package:prepgenie/features/chapter/domain/entities/sub_chapters_list.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import 'course_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CourseRemoteDataSource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<CoursesLocalDatasource>(),
])
void main() {
  late MockCourseRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late MockCoursesLocalDatasource localDatasource;
  late MockFlutterSecureStorage flutterSecureStorage;
  late CourseRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockCourseRemoteDataSource();
    localDatasource = MockCoursesLocalDatasource();
    flutterSecureStorage = MockFlutterSecureStorage();
    networkInfo = MockNetworkInfo();

    repositoryImpl = CourseRepositoryImpl(
        networkInfo: networkInfo,
        remoteDataSource: remoteDataSource,
        coursesLocalDatasource: localDatasource,
        flutterSecureStorage: flutterSecureStorage);
  });

  const tCourse = Course(
      id: "1",
      cariculumIsNew: true,
      departmentId: "dep_id",
      description: "test course description",
      ects: "10",
      grade: 12,
      image: CourseImage(imageAddress: "image address"),
      name: "test course name",
      numberOfChapters: 5,
      referenceBook: "test referance book");
  const tCourseList = [tCourse];
  const tUserCourse = [
    UserCourse(
        id: "test user course id",
        userId: "test user id",
        course: tCourse,
        completedChapters: 1)
  ];
  const tId = "test id";

  const tChapter = Chapter(
      noOfSubchapters: 2,
      id: "id",
      courseId: "courseId",
      name: "name",
      description: "description",
      summary: "summary",
      order: 1);

  const tSubChapters = [
    SubChapterList(
        id: "id",
        chapterId: "chapter id",
        subChapterName: "name",
        isCompleted: true)
  ];

  const userChaptersAnalysis = [
    UserChapterAnalysis(
        id: "id",
        chapter: tChapter,
        completedSubChapters: 2,
        subchapters: tSubChapters)
  ];
  const subChapterVideos = [
    SubchapterVideoModel(
        id: 'id',
        courseId: "courseId",
        chapterId: 'chapterId',
        subChapterId: 'subChapterId',
        order: 1,
        title: 'title',
        videoLink: 'videoLink',
        duration: "30 min",
        thumbnailUrl: "thumbnailUrl")
  ];
  const chapterVideos = [
    ChapterVideoModel(
        id: "id",
        description: "description",
        summary: "summary",
        courseId: "courseId",
        numberOfSubChapters: 1,
        title: 'title',
        order: 1,
        subchapterVideos: subChapterVideos)
  ];
  const departmentCourse = DepartmentCourse(
      biology: tCourseList,
      chemistry: tCourseList,
      civics: tCourseList,
      english: tCourseList,
      maths: tCourseList,
      physics: tCourseList,
      sat: tCourseList,
      others: tCourseList,
      economics: tCourseList,
      history: tCourseList,
      geography: tCourseList,
      business: tCourseList);

  const userCourseAnalysis = UserCourseAnalysis(
      course: tCourse, userChaptersAnalysis: userChaptersAnalysis);

  const chatHistory = [
    ChatHistory(
      human: "Human chat",
      ai: "AI chat",
    ),
  ];

  const chatBody = ChatBody(
    isContest: true,
    questionId: "questionId",
    userQuestion: "userQuestion",
    chatHistory: chatHistory,
  );

  const chatResponse = ChatResponseModel(messageResponse: "message response");

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

//  Test Get user course function
  group('getUserCourse', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getUserCourses(true);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getUserCourses call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getUserCourses())
            .thenAnswer((_) async => tUserCourse);
        // act
        final result = await repositoryImpl.getUserCourses(true);
        // assert
        verify(remoteDataSource.getUserCourses());
        expect(result, equals(const Right(tUserCourse)));
      });
    });

    test(
        'should cache the getUserCourse when the getUserCourses call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getUserCourses())
          .thenAnswer((_) async => tUserCourse);
      // act
      await repositoryImpl.getUserCourses(true);
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  runTestOffline(() {
    test(
        'should return network failure when getUserCourses call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result = await repositoryImpl.getUserCourses(true);
      // assert
      verify(networkInfo.isConnected);
      verify(localDatasource.getCachedUserCourses());
      expect(result, Left(NetworkFailure()));
    });

    test("Should return user course form local data source", () async {
      when(localDatasource.getCachedUserCourses())
          .thenAnswer((_) async => (tUserCourse));
      final result = await repositoryImpl.getUserCourses(true);
      expect(result, const Right(tUserCourse));
      verify(localDatasource.getCachedUserCourses());
      verifyNoMoreInteractions(localDatasource);
    });
  });

//  Test Get Course By Id function
  group('getCourseById', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getCourseById(id: tId, isRefreshed: true);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course analysis when the getCourseById call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getCourseById(tId))
            .thenAnswer((_) async => userCourseAnalysis);
        // act
        final result =
            await repositoryImpl.getCourseById(id: tId, isRefreshed: true);
        // assert
        verify(remoteDataSource.getCourseById(tId));
        expect(result, equals(const Right(userCourseAnalysis)));
      });
    });

    test(
        'should cache the user course analysis when the getCourseById call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getCourseById(tId))
          .thenAnswer((_) async => userCourseAnalysis);
      // act
      await repositoryImpl.getCourseById(id: tId, isRefreshed: true);
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  runTestOffline(() {
    test(
        'should return network failure when getCourseById call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result =
          await repositoryImpl.getCourseById(id: tId, isRefreshed: true);
      // assert
      verify(networkInfo.isConnected);
      verify(localDatasource.getCachedCourseById(tId));
      expect(result, Left(NetworkFailure()));
    });
  });

// Test Get Courses By Department Id function
  group('getCoursesByDepartmentId', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getCoursesByDepartmentId(tId);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of course analysis when the getCoursesByDepartmentId call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getCoursesByDepartmentId(tId))
            .thenAnswer((_) async => tCourseList);
        // act
        final result = await repositoryImpl.getCoursesByDepartmentId(tId);
        // assert
        verify(remoteDataSource.getCoursesByDepartmentId(tId));
        expect(result, equals(const Right(tCourseList)));
      });
    });

    test(
        'should cache  list of courses  when the getCoursesByDepartmentId call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getCoursesByDepartmentId(tId))
          .thenAnswer((_) async => tCourseList);
      // act
      await repositoryImpl.getCoursesByDepartmentId(tId);
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  runTestOffline(() {
    test(
        'should return network failure when getCoursesByDepartmentId call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result = await repositoryImpl.getCoursesByDepartmentId(tId);
      // assert
      verify(networkInfo.isConnected);

      expect(result, Left(NetworkFailure()));
    });
  });

  // Test chat function

  group('chat', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.chat(chatBody.isContest, chatBody.questionId,
          chatBody.userQuestion, chatHistory);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of course analysis when the getCoursesByDepartmentId call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.chat(chatBody.isContest, chatBody.questionId,
                chatBody.userQuestion, chatHistory))
            .thenAnswer((_) async => chatResponse);
        // act
        final result = await repositoryImpl.chat(chatBody.isContest,
            chatBody.questionId, chatBody.userQuestion, chatHistory);
        // assert
        verify(remoteDataSource.chat(chatBody.isContest, chatBody.questionId,
            chatBody.userQuestion, chatHistory));
        expect(result, equals(const Right(chatResponse)));
      });
    });

    test(
        'should cache  list of courses  when the getCoursesByDepartmentId call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.chat(chatBody.isContest, chatBody.questionId,
              chatBody.userQuestion, chatHistory))
          .thenAnswer((_) async => chatResponse);
      // act
      await repositoryImpl.chat(chatBody.isContest, chatBody.questionId,
          chatBody.userQuestion, chatHistory);
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  runTestOffline(() {
    test(
        'should return network failure when getCoursesByDepartmentId call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result = await repositoryImpl.chat(chatBody.isContest,
          chatBody.questionId, chatBody.userQuestion, chatHistory);
      // assert
      verify(networkInfo.isConnected);

      expect(result, Left(NetworkFailure()));
    });
  });

// Test fetch Course Videos function
  group('fetchCourseVideos', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.fetchCourseVideos(tId);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of chapter video model when the fetchCourseVideos call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.fetchCourseVideos(tId))
            .thenAnswer((_) async => chapterVideos);
        // act
        final result = await repositoryImpl.fetchCourseVideos(tId);
        // assert
        verify(remoteDataSource.fetchCourseVideos(tId));
        expect(result, equals(const Right(chapterVideos)));
      });
    });

    test(
        'should cache  list of courses  when the fetchCourseVideos call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.fetchCourseVideos(tId))
          .thenAnswer((_) async => chapterVideos);
      // act
      await repositoryImpl.fetchCourseVideos(tId);
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  runTestOffline(() {
    test(
        'should return network failure when fetchCourseVideos call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result = await repositoryImpl.fetchCourseVideos(tId);
      // assert
      verify(networkInfo.isConnected);

      expect(result, Left(NetworkFailure()));
    });
  });

  // Test get Department Course function

  group('getDepartmentCourse', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getDepartmentCourse(tId);
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of Department courses when the getDepartmentCourse call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getDepartmentCourse(tId))
            .thenAnswer((_) async => departmentCourse);
        // act
        final result = await repositoryImpl.getDepartmentCourse(tId);
        // assert
        verify(remoteDataSource.getDepartmentCourse(tId));
        expect(result, equals(const Right(departmentCourse)));
      });
    });

    test(
        'should cache  list of department courses  when the getDepartmentCourse call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getDepartmentCourse(tId))
          .thenAnswer((_) async => departmentCourse);
      // act
      await repositoryImpl.getDepartmentCourse(tId);
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  runTestOffline(() {
    test(
        'should return network failure when getDepartmentCourse call to the remote data source is unsuccessful with device connection offline',
        () async {
      // act
      final result = await repositoryImpl.getDepartmentCourse(tId);
      // assert
      verify(networkInfo.isConnected);

      expect(result, Left(NetworkFailure()));
    });
  });
}
