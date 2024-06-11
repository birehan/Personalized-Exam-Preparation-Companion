import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/bookmark_content_usecase.dart';
import 'package:prep_genie/features/bookmarks/presentation/bloc/addContentBookmarkBloc/add_content_bookmark_bloc_bloc.dart';

import 'add_content_bookmark_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ContentBookmarkUsecase>(),
])
void main() {
  late MockContentBookmarkUsecase mockContentBookmarkUsecase;

  setUp(() {
    mockContentBookmarkUsecase = MockContentBookmarkUsecase();
  });
  blocTest<AddContentBookmarkBlocBloc, AddContentBookmarkBlocState>(
    'emits [ContentBookmarkAddingState , ContentBookmarkAddedState] when DispatchLogoutEvent is added and logout successful',
    build: () => AddContentBookmarkBlocBloc(
        contentBookmarkUsecase: mockContentBookmarkUsecase),
    act: (bloc) =>
        bloc.add(const ContentBookmarkAddedEvent(contentId: 'contentId')),
    setUp: () => when(mockContentBookmarkUsecase(any))
        .thenAnswer((_) async => const Right(true)),
    expect: () => [
      ContentBookmarkAddingState(),
      ContentBookmarkAddedState(),
    ],
    verify: (_) {
      verify(mockContentBookmarkUsecase(any)).called(1);
    },
  );
}
