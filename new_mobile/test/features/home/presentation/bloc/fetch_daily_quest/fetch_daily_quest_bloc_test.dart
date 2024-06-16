import 'package:mockito/annotations.dart';
import 'package:prep_genie/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/error/failure.dart';

import 'fetch_daily_quest_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchDailyQuestUsecase>()])
void main() {
  late FetchDailyQuestBloc bloc;
  late MockFetchDailyQuestUsecase mockGetExamDateUsecase;

  setUp(() {
    mockGetExamDateUsecase = MockFetchDailyQuestUsecase();
    bloc = FetchDailyQuestBloc(fetchDailyQuestUsecase: mockGetExamDateUsecase);
  });

  const dailyQuest = [
    DailyQuest(challenge: "challenge", expected: 3, completed: 1)
  ];
  group('_onFetchDailyQuest', () {
    test('should get data from the fetch daily quest usecase', () async {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async => const Right(dailyQuest));
      // act
      bloc.add(const FetchDailyQuestEvent());

      await untilCalled(mockGetExamDateUsecase(any));
      // assert
      verify(mockGetExamDateUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async => const Right(dailyQuest));
      // assert later
      final expected = [
        FetchDailyQuestLoading(),
        const FetchDailyQuestLoaded(dailyQuests: dailyQuest)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuestEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        FetchDailyQuestLoading(),
        FetchDailyQuestFailed(
            errorMessage: "Server failure", failure: ServerFailure())
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuestEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        FetchDailyQuestLoading(),
        FetchDailyQuestFailed(
            errorMessage: "Cache failure", failure: CacheFailure())
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuestEvent());
    });
  });
}
