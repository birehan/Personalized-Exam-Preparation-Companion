import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';

void main() {
  late FetchDailyStreakUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = FetchDailyStreakUsecase(repository: mockHomeRepository);
  });

  final date = DateTime.now();
  const totalStreak = TotalStreak(maxStreak: 3, currentStreak: 1, points: 45);
  final userDailyStreaks = [UserDailyStreak(date: date, activeOnDay: true)];
  final dailyStreak =
      DailyStreak(userDailyStreaks: userDailyStreaks, totalStreak: totalStreak);

  test(
    "Should get list of daily streak from repository",
    () async {
      when(mockHomeRepository.fetchDailyStreak(date, date))
          .thenAnswer((_) async => Right(dailyStreak));

      final result = await usecase
          .call(FetchDailyStreakParams(startDate: date, endDate: date));

      expect(result, Right(dailyStreak));

      verify(mockHomeRepository.fetchDailyStreak(date, date));

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
