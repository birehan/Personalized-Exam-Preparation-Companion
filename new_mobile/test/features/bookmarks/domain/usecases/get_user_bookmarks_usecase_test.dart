import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/bookmarks/domain/domain.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/bookmark_question_usecase.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/delete_bookmarked_content.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/delete_bookmarked_question_usecase.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/question/domain/entities/user_answer.dart'
    as user_answer;
import 'bookmark_content_usecase_test.mocks.dart';

void main() {
  late MockBookmarkRepositories mockBookmarkRepositories;
  late GetUserBookmarksUsecase getUserBookmarksUsecase;

  setUp(() {
    mockBookmarkRepositories = MockBookmarkRepositories();
    getUserBookmarksUsecase =
        GetUserBookmarksUsecase(bookmarkRepositories: mockBookmarkRepositories);
  });
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
    userAnswer: const user_answer.UserAnswer(
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
  test(
    "Should delete bookmarked question",
    () async {
      when(mockBookmarkRepositories.getUserBookmarks())
          .thenAnswer((_) async => Right(bookmarks));

      final result = await getUserBookmarksUsecase.call(NoParams());

      expect(result, equals(Right(bookmarks)));

      verify(mockBookmarkRepositories.getUserBookmarks()).called(1);
    },
  );
}
