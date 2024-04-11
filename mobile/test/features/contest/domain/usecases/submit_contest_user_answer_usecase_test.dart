import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_upcoming_user_contest_usecase_test.mocks.dart';

void main() {
  late MockContestRepository mockContestRepository;
  late SubmitContestUserAnswerUsecase usecase;

  setUp(() {
    mockContestRepository = MockContestRepository();
    usecase = SubmitContestUserAnswerUsecase(repository: mockContestRepository);
  });

  const contestUserAnswer = ContestUserAnswer(
    contestCategoryId: '65a039b436331438555aead2',
    userAnswers: [
      ContestAnswer(
        contestQuestionId: '65a039ce36331438555aead4',
        userAnswer: 'choice_B',
      ),
    ],
  );

  test('should get unit by calling SubmitContestUserAnswerUsecase',
      () async {
    // arrange
    when(mockContestRepository.submitUserContestAnswer(contestUserAnswer))
        .thenAnswer((_) async => const Right(unit));
    // act
    final result = await usecase(
      const SubmitContestUserAnswerParams(contestUserAnswer: contestUserAnswer),
    );
    // assert
    expect(result, const Right(unit));
    verify(mockContestRepository.submitUserContestAnswer(contestUserAnswer));
    verifyNoMoreInteractions(mockContestRepository);
  });
}
