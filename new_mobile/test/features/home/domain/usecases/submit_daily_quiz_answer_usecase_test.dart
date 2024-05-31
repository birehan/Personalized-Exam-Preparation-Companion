import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';
void main() {
  late SubmitDailyQuizAnswerUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = SubmitDailyQuizAnswerUsecase(repository: mockHomeRepository);
  });
  const userAnswer = [
    DailyQuizUserAnswer(questionId: "questionId", userAnswer: "userAnswer")
  ];
  const dailyQuizAnswer =
      DailyQuizAnswer(dailyQuizId: "dailyQuizId", userAnswer: userAnswer);

  test(
    "Should submit daily quiz answer from repository",
    () async {
      when(mockHomeRepository.submitDailyQuizAnswer(dailyQuizAnswer))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase.call(
          const SubmitDailyQuizAnswerParams(dailyQuizAnswer: dailyQuizAnswer));

      expect(result, const Right(unit));

      verify(mockHomeRepository.submitDailyQuizAnswer(dailyQuizAnswer));

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
