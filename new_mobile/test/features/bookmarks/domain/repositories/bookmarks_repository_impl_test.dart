import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/network/network.dart';
import 'package:prep_genie/features/bookmarks/data/datasources/bookmarks_remote_datasource.dart';
import 'package:prep_genie/features/bookmarks/data/repositories/bookmarks_repository_impl.dart';
import 'package:prep_genie/features/bookmarks/domain/entities/bookmarked_contents.dart';
import 'package:prep_genie/features/bookmarks/domain/entities/bookmarked_contents_and_questions.dart';
import 'package:prep_genie/features/bookmarks/domain/entities/bookmarked_questions.dart';
import 'package:prep_genie/features/chapter/domain/entities/content.dart';
import 'package:prep_genie/features/question/domain/entities/question.dart';
import 'package:prep_genie/features/question/domain/entities/user_answer.dart';

import 'bookmarks_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BookmarksRemoteDatasource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late MockBookmarksRemoteDatasource mockBookmarkRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late BookmarksReposirotyImpl repositoryImpl;

  setUp(() {
    mockBookmarkRemoteDataSource = MockBookmarksRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = BookmarksReposirotyImpl(
        bookmarksRemoteDatasource: mockBookmarkRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });
  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  final bookmarkedQuestions = BookmarkedQuestions(
    question: const Question(
        isLiked: true,
        id: 'questionId',
        courseId: 'courseId',
        chapterId: 'chapterId',
        subChapterId: 'subChapterId',
        description: 'description',
        choiceA: 'choiceA',
        choiceB: 'choiceB',
        choiceC: 'choiceC',
        choiceD: 'choiceD',
        answer: 'answer',
        explanation: 'explanation',
        isForQuiz: true),
    bookmarkedTime: DateTime.now(),
    isLiked: true,
    userAnswer: const UserAnswer(
        userId: 'userId', questionId: 'questionId', userAnswer: 'userAnswer'),
  );
  final bookmarkedContent = BookmarkedContent(
      bookmarkedTime: DateTime.now(),
      id: 'id',
      userId: 'userId',
      content: const Content(
          id: 'id',
          subChapterId: 'subChapterId',
          title: 'title',
          content: 'content',
          isBookmarked: true));
  final bookmarks = Bookmarks(
      bookmakredQuestions: [bookmarkedQuestions],
      bookmarkedContents: [bookmarkedContent]);

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('bookmark a content', () {
    group('bookmark content ', () {
      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repositoryImpl.bookmarkContent('contentId');
        // assert
        verify(mockNetworkInfo.isConnected);
      });
      runTestsOnline(() {
        test(
            'should return true when the getUserProfile call to remote data source is successful',
            () async {
          // arrange
          when(mockBookmarkRemoteDataSource.bookmarkContent('contentId'))
              .thenAnswer((_) async => true);
          // act
          final result = await repositoryImpl.bookmarkContent('contentId');
          // assert
          verify(mockBookmarkRemoteDataSource.bookmarkContent('contentId'));
          expect(result, equals(const Right(true)));
        });
      });
    });
  });
  group('bookmark a question', () {
    group('bookmark question ', () {
      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repositoryImpl.bookmarkQuestion('questionId');
        // assert
        verify(mockNetworkInfo.isConnected);
      });
      runTestsOnline(() {
        test(
            'should return true when the bookmarkQuestion call to remote data source is successful',
            () async {
          // arrange
          when(mockBookmarkRemoteDataSource.bookmarkQuestion('questionId'))
              .thenAnswer((_) async {});
          // act
          await repositoryImpl.bookmarkQuestion('questionId');
          // assert
          verify(mockBookmarkRemoteDataSource.bookmarkQuestion('questionId'));
        });
      });
    });
  });
  // test logout
  group('remove bookmark content', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.removeBookmarkedContent('contentId');
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test('should return noting when remove content called', () async {
        // arrange
        when(mockBookmarkRemoteDataSource.removeContentBookmark('contentId'))
            .thenAnswer((_) async {});
        // act
        final result =
            await repositoryImpl.removeBookmarkedContent('contentId');

        // assert
        verify(mockBookmarkRemoteDataSource.removeContentBookmark('contentId'));
        expect(result, const Right(Void));
      });
    });
  });

  group('remove bookmark question', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.removeBookmarkedContent('contentId');
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test('should return noting when remove content called', () async {
        // arrange
        when(mockBookmarkRemoteDataSource.removeQuestionBookmark('questionId'))
            .thenAnswer((_) async {});
        // act

        await repositoryImpl.removeQuestionBookmark('questionId');

        // assert
        verify(
            mockBookmarkRemoteDataSource.removeQuestionBookmark('questionId'));
      });
    });
  });

  group('get saved bookmarks', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.removeBookmarkedContent('contentId');
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test('should return bookmarks when get bookmarks is called', () async {
        // arrange
        when(mockBookmarkRemoteDataSource.getUserBookmarks())
            .thenAnswer((_) async => bookmarks);
        // act

        final result = await repositoryImpl.getUserBookmarks();

        // assert
        verify(mockBookmarkRemoteDataSource.getUserBookmarks());
        expect(result, Right(bookmarks));
      });
    });
  });
}
