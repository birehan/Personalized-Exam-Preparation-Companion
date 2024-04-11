import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';

void main() {
  late FetchDailyQuizUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = FetchDailyQuizUsecase(repository: mockHomeRepository);
  });

  const dailyQuiz = DailyQuiz(id: "id", description: "description", dailyQuizQuestions: [], userScore: 3);

  test(
    "Should get list of daily quiz from repository",
    () async {
      when(mockHomeRepository.fetchDailyQuiz())
          .thenAnswer((_) async => const Right(dailyQuiz));

      final result = await usecase.call(NoParams());

      expect(result, const Right(dailyQuiz));

      verify(mockHomeRepository.fetchDailyQuiz());

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
