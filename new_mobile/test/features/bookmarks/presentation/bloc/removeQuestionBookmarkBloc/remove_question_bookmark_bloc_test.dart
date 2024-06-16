import 'dart:ffi';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/bookmark_content_usecase.dart';
import 'package:prep_genie/features/bookmarks/domain/usecases/delete_bookmarked_question_usecase.dart';
import 'package:prep_genie/features/bookmarks/presentation/bloc/deleteQuestionBookmarkBloc/delete_question_bookmark_bloc.dart';

import 'remove_question_bookmark_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DeleteQuestionBookmarkUsecase>(),
])
void main() {
  late MockDeleteQuestionBookmarkUsecase mockDeleteQuestionBookmarkUsecase;

  setUp(() {
    mockDeleteQuestionBookmarkUsecase = MockDeleteQuestionBookmarkUsecase();
  });
  blocTest<DeleteQuestionBookmarkBloc, DeleteQuestionBookmarkState>(
    'emits [DeleteQuestionBookmarkLoading , DeleteQuestionBookmarkSuccessState] when DispatchLogoutEvent is added and logout successful',
    build: () => DeleteQuestionBookmarkBloc(
        deleteQuestionBookmarkUsecase: mockDeleteQuestionBookmarkUsecase),
    act: (bloc) =>
        bloc.add(const QeustionBookmarkDeletedEvent(questionId: 'questionId')),
    setUp: () => when(mockDeleteQuestionBookmarkUsecase(any))
        .thenAnswer((_) async => const Right(Void)),
    expect: () => [
      DeleteQuestionBookmarkLoading(),
      DeleteQuestionBookmarkSuccessState(),
    ],
    verify: (_) {
      verify(mockDeleteQuestionBookmarkUsecase(any)).called(1);
    },
  );
}
