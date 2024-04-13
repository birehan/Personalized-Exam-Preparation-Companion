import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/bookmarks/domain/domain.dart';
import 'package:prepgenie/features/bookmarks/domain/repositories/bookmark_repositoires.dart';

import 'bookmark_content_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BookmarkRepositories>(),
])
void main() {
  late MockBookmarkRepositories mockBookmarkRepositories;
  late ContentBookmarkUsecase contentBookmarkUsecase;

  setUp(() {
    mockBookmarkRepositories = MockBookmarkRepositories();
    contentBookmarkUsecase =
        ContentBookmarkUsecase(bookmarkRepositories: mockBookmarkRepositories);
  });

  test(
    "Should bookmark a content",
    () async {
      when(mockBookmarkRepositories.bookmarkContent('contentId'))
          .thenAnswer((_) async => const Right(true));

      final result = await contentBookmarkUsecase
          .call(ContentBookmarkParams(contnetId: 'contentId'));

      expect(result, equals(const Right(true)));

      verify(mockBookmarkRepositories.bookmarkContent('contentId')).called(1);
    },
  );
}
