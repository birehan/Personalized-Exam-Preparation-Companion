import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';


@GenerateNiceMocks([MockSpec<HomeRepository>()])
void main() {
  late FetchDailyQuestUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = FetchDailyQuestUsecase(repository: mockHomeRepository);
  });

  const dailyQuest = [DailyQuest(challenge: "challenge", expected: 3, completed: 1)];

  test(
    "Should get list of daily quest from repository",
    () async {
      when(mockHomeRepository.fetchDailyQuest())
          .thenAnswer((_) async => const Right(dailyQuest));

      final result = await usecase.call(NoParams());

      expect(result, const Right(dailyQuest));

      verify(mockHomeRepository.fetchDailyQuest());

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
