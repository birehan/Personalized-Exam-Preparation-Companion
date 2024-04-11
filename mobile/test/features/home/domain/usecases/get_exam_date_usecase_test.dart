import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';
void main() {
  late GetExamDateUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = GetExamDateUsecase(mockHomeRepository);
  });
  final date = DateTime.now();
  final examDates = [ExamDate(id: "id", date: date)];

  test(
    "Should get list of exam date from repository",
    () async {
      when(mockHomeRepository.getExamDate())
          .thenAnswer((_) async => Right(examDates));

      final result = await usecase.call(NoParams());

      expect(result, Right(examDates));

      verify(mockHomeRepository.getExamDate());

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
