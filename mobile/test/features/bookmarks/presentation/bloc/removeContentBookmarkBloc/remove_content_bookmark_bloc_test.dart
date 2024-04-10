import 'dart:ffi';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/bookmark_content_usecase.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/delete_bookmarked_content.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/deleteContentBookmark/delete_content_bookmark_bloc.dart';

import 'remove_content_bookmark_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DeleteContentBookmarkUsecase>(),
])
void main() {
  late MockDeleteContentBookmarkUsecase mockDeleteContentBookmarkUsecase;

  setUp(() {
    mockDeleteContentBookmarkUsecase = MockDeleteContentBookmarkUsecase();
  });
  blocTest<DeleteContentBookmarkBloc, DeleteContentBookmarkState>(
    'emits [ContnetBookmarkDeletingState , ContentBookmarkDeletedState] when DispatchLogoutEvent is added and logout successful',
    build: () => DeleteContentBookmarkBloc(
        deleteContentBookmarkUsecase: mockDeleteContentBookmarkUsecase),
    act: (bloc) =>
        bloc.add(const BookmarkedContentDeletedEvent(contentId: 'contentId')),
    setUp: () => when(mockDeleteContentBookmarkUsecase(any))
        .thenAnswer((_) async => const Right(Void)),
    expect: () => [
      ContnetBookmarkDeletingState(),
      ContentBookmarkDeletedState(),
    ],
    verify: (_) {
      verify(mockDeleteContentBookmarkUsecase(any)).called(1);
    },
  );
}
