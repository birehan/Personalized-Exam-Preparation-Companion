import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/bookmark_question_usecase.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/delete_bookmarked_content.dart';

import 'bookmark_content_usecase_test.mocks.dart';

void main() {
  late MockBookmarkRepositories mockBookmarkRepositories;
  late DeleteContentBookmarkUsecase deleteContentBookmarkUsecase;

  setUp(() {
    mockBookmarkRepositories = MockBookmarkRepositories();
    deleteContentBookmarkUsecase = DeleteContentBookmarkUsecase(
        bookmarkRepositories: mockBookmarkRepositories);
  });

  test(
    "Should delete bookmarked content",
    () async {
      when(mockBookmarkRepositories.removeBookmarkedContent('contentId'))
          .thenAnswer((_) async => const Right(Void));

      final result = await deleteContentBookmarkUsecase
          .call(DeleteContentBookmarkParams(contentId: 'contentId'));

      expect(result, equals(const Right(Void)));

      verify(mockBookmarkRepositories.removeBookmarkedContent('contentId'))
          .called(1);
    },
  );
}
