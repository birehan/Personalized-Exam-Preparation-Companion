import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/features.dart';

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';

void main() {
  late UpsertMockScoreUsecase usecase;
  late MockMockExamRepository mockExamRepository;

  setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = UpsertMockScoreUsecase(mockExamRepository);
  });

  const tId = "test id";

  test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.upsertMockScore(tId, 3))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase
          .call(const UpsertMockScoreParams(mockId: tId, score: 3));

      expect(result, const Right(unit));

      verify(mockExamRepository.upsertMockScore(tId, 3));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );
}
