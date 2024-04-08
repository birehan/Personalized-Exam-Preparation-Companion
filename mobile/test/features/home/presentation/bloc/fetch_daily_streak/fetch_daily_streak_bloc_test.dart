import 'package:mockito/annotations.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';

import 'fetch_daily_streak_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchDailyStreakUsecase>()])
void main() {
  late FetchDailyStreakBloc bloc;
  late MockFetchDailyStreakUsecase mockFetchDailyStreakUsecase;

  setUp(() {
    mockFetchDailyStreakUsecase = MockFetchDailyStreakUsecase();
    bloc = FetchDailyStreakBloc(
        fetchDailyStreakUsecase: mockFetchDailyStreakUsecase);
  });

  final date = DateTime.now();
  const totalStreak = TotalStreak(maxStreak: 3, currentStreak: 1, points: 45);
  final userDailyStreaks = [UserDailyStreak(date: date, activeOnDay: true)];
  final dailyStreak =
      DailyStreak(userDailyStreaks: userDailyStreaks, totalStreak: totalStreak);

  group('_onFetchDailyQuizForAnalysis', () {
    test('should get data from the fetch daily quiz for analysis usecase',
        () async {
      // arrange
      when(mockFetchDailyStreakUsecase(any))
          .thenAnswer((_) async => Right(dailyStreak));
      // act
      bloc.add(FetchDailyStreakEvent(endDate: date, startDate: date));

      await untilCalled(mockFetchDailyStreakUsecase(any));
      // assert
      verify(mockFetchDailyStreakUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockFetchDailyStreakUsecase(any))
          .thenAnswer((_) async => Right(dailyStreak));
      // assert later
      final expected = [
        FetchDailyStreakLoading(),
        FetchDailyStreakLoaded(dailyStreak: dailyStreak)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchDailyStreakEvent(endDate: date, startDate: date));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockFetchDailyStreakUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        FetchDailyStreakLoading(),
        const FetchDailyStreakFailed(errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchDailyStreakEvent(endDate: date, startDate: date));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockFetchDailyStreakUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        FetchDailyStreakLoading(),
        const FetchDailyStreakFailed(errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchDailyStreakEvent(endDate: date, startDate: date));
    });
  });
}
