import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/bookmark_content_usecase.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/bookmark_question_usecase.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/addQuestionBookmarkBloc/add_question_bookmark_bloc.dart';

import 'add_question_bookmark_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<QuestionBookmarkUsecase>(),
])
void main() {
  late MockQuestionBookmarkUsecase mockQuestionBookmarkUsecase;

  setUp(() {
    mockQuestionBookmarkUsecase = MockQuestionBookmarkUsecase();
  });
  blocTest<AddQuestionBookmarkBloc, AddQuestionBookmarkState>(
    'emits [AddQuestionBookmarkAddingState , AddQuestionBookmarkSuccessState] when DispatchLogoutEvent is added and logout successful',
    build: () => AddQuestionBookmarkBloc(
        questionBookmarkUsecase: mockQuestionBookmarkUsecase),
    act: (bloc) =>
        bloc.add(const QuestionBookmarkAddedEvent(questionId: 'questionId')),
    setUp: () => when(mockQuestionBookmarkUsecase(any))
        .thenAnswer((_) async => const Right(true)),
    expect: () => [
      AddQuestionBookmarkAddingState(),
      AddQuestionBookmarkSuccessState(),
    ],
    verify: (_) {
      verify(mockQuestionBookmarkUsecase(any)).called(1);
    },
  );
}
