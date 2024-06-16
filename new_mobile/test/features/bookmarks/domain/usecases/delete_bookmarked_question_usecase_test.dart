import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/bookmark_question_usecase.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/delete_bookmarked_content.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/delete_bookmarked_question_usecase.dart';

import 'bookmark_content_usecase_test.mocks.dart';

void main() {
  late MockBookmarkRepositories mockBookmarkRepositories;
  late DeleteQuestionBookmarkUsecase deleteQuestionBookmarkUsecase;

  setUp(() {
    mockBookmarkRepositories = MockBookmarkRepositories();
    deleteQuestionBookmarkUsecase = DeleteQuestionBookmarkUsecase(
        bookmarkRepositories: mockBookmarkRepositories);
  });

  test(
    "Should delete bookmarked question",
    () async {
      when(mockBookmarkRepositories.removeQuestionBookmark('questionId'))
          .thenAnswer((_) async => const Right(Void));

      final result = await deleteQuestionBookmarkUsecase
          .call(DeleteQuestionBookmarkParams(questionId: 'questionId'));

      expect(result, equals(const Right(Void)));

      verify(mockBookmarkRepositories.removeQuestionBookmark('questionId'))
          .called(1);
    },
  );
}
