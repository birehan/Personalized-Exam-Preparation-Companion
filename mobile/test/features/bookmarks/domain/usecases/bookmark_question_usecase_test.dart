import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/bookmark_question_usecase.dart';

import 'bookmark_content_usecase_test.mocks.dart';

void main() {
  late MockBookmarkRepositories mockBookmarkRepositories;
  late QuestionBookmarkUsecase questionBookmarkUsecase;

  setUp(() {
    mockBookmarkRepositories = MockBookmarkRepositories();
    questionBookmarkUsecase =
        QuestionBookmarkUsecase(bookmarkRepositories: mockBookmarkRepositories);
  });

  test(
    "Should bookmark a question",
    () async {
      when(mockBookmarkRepositories.bookmarkQuestion('questionId'))
          .thenAnswer((_) async => const Right(true));

      final result = await questionBookmarkUsecase
          .call(QuestionBookmarkParams(questionId: 'questionId'));

      expect(result, equals(const Right(true)));

      verify(mockBookmarkRepositories.bookmarkQuestion('questionId')).called(1);
    },
  );
}
