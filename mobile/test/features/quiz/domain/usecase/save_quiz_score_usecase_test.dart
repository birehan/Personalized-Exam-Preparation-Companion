
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:skill_bridge_mobile/features/quiz/domain/usecases/save_quiz_score_usecase.dart';

import 'save_quiz_score_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<QuizRepository>()])

void main(){
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

      final result = await usecase.call(const SaveQuizScoreParams(quizId: tId, score: score));

      expect(result, const Right(unit));

      verify(mockQuizRepository.saveQuizScore(quizId: tId, score: score));

      verifyNoMoreInteractions(mockQuizRepository);
    },
  );
}

