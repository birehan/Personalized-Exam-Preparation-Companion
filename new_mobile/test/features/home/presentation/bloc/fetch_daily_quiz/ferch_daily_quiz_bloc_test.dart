import 'package:mockito/annotations.dart';
import 'package:prep_genie/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/error/failure.dart';

import 'ferch_daily_quiz_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchDailyQuizUsecase>()])
void main() {
  late FetchDailyQuizBloc bloc;
  late MockFetchDailyQuizUsecase mockFetchDailyQuizUsecase;

  setUp(() {
    mockFetchDailyQuizUsecase = MockFetchDailyQuizUsecase();
    bloc = FetchDailyQuizBloc(fetchDailyQuizUsecase: mockFetchDailyQuizUsecase);
  });

  const dailyQuiz = DailyQuiz(
      id: "id",
      description: "description",
      dailyQuizQuestions: [],
      userScore: 3);
  group('_onFetchDailyQuiz', () {
    test('should get data from the fetch daily quiz usecase', () async {
      // arrange
      when(mockFetchDailyQuizUsecase(any))
          .thenAnswer((_) async => const Right(dailyQuiz));
      // act
      bloc.add(const FetchDailyQuizEvent());

      await untilCalled(mockFetchDailyQuizUsecase(any));
      // assert
      verify(mockFetchDailyQuizUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockFetchDailyQuizUsecase(any))
          .thenAnswer((_) async => const Right(dailyQuiz));
      // assert later
      final expected = [
        FetchDailyQuizLoading(),
        const FetchDailyQuizLoaded(dailyQuiz: dailyQuiz)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuizEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockFetchDailyQuizUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        FetchDailyQuizLoading(),
        const FetchDailyQuizFailed(errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuizEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockFetchDailyQuizUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        FetchDailyQuizLoading(),
        const FetchDailyQuizFailed(errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuizEvent());
    });
  });
}
