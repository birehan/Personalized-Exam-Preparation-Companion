import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';
void main() {
  late FetchDailyQuizForAnalysisUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = FetchDailyQuizForAnalysisUsecase(repository: mockHomeRepository);
  });

  const dailyQuiz = DailyQuiz(id: "id", description: "description", dailyQuizQuestions: [], userScore: 3);

  test(
    "Should get list of daily quest from repository",
    () async {
      when(mockHomeRepository.fetchDailyQuizForAnalysis("id"))
          .thenAnswer((_) async => const Right(dailyQuiz));

      final result = await usecase.call(const FetchDailyQuizForAnalysisParams(id: "id"));

      expect(result, const Right(dailyQuiz));

      verify(mockHomeRepository.fetchDailyQuizForAnalysis("id"));

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
