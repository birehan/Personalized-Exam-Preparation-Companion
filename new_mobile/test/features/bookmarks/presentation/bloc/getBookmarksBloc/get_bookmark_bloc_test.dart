import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/bookmarks/domain/domain.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/bookmark_content_usecase.dart';
import 'package:prep_genie/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:prep_genie/features/chapter/domain/entities/content.dart';
import 'package:prep_genie/features/question/domain/entities/question.dart';
import 'package:prep_genie/features/question/domain/entities/user_answer.dart'
    as user_answer;
import 'get_bookmark_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetUserBookmarksUsecase>(),
])
void main() {
  late MockGetUserBookmarksUsecase mockGetUserBookmarksUsecase;

  setUp(() {
    mockGetUserBookmarksUsecase = MockGetUserBookmarksUsecase();
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

  blocTest<BookmarksBlocBloc, BookmarksBlocState>(
    'emits [BookmarksLoadingState , BookmarksLoadedState] when DispatchLogoutEvent is added and logout successful',
    build: () =>
        BookmarksBlocBloc(getUserBookmarksUsecase: mockGetUserBookmarksUsecase),
    act: (bloc) => bloc.add(GetBookmarksEvent()),
    setUp: () => when(mockGetUserBookmarksUsecase(any))
        .thenAnswer((_) async => Right(bookmarks)),
    expect: () => [
      BookmarksLoadingState(),
      BookmarksLoadedState(bookmarks: bookmarks),
    ],
    verify: (_) {
      verify(mockGetUserBookmarksUsecase(any)).called(1);
    },
  );
}
