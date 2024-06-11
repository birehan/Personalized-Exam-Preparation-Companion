import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/quiz/domain/usecases/save_quiz_score_usecase.dart';

import 'save_quiz_score_usecase_test.mocks.dart';

void main() {
  late SaveQuizScoreUsecase usecase;
  late MockQuizRepository mockQuizRepository;

  setUp(() {
    mockQuizRepository = MockQuizRepository();
    usecase = SaveQuizScoreUsecase(mockQuizRepository);
  });

  const tId = "test id";
  const score = 3;

  test(
    "Should save quize score from repository",
    () async {
      when(mockQuizRepository.saveQuizScore(quizId: tId, score: score))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase
          .call(const SaveQuizScoreParams(quizId: tId, score: score));

      expect(result, const Right(unit));

      verify(mockQuizRepository.saveQuizScore(quizId: tId, score: score));

      verifyNoMoreInteractions(mockQuizRepository);
    },
  );
}
