import 'package:mockito/annotations.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';

import 'fetch_daily_quiz_for_analysis_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchDailyQuizForAnalysisUsecase>()])
void main() {
  late FetchDailyQuizForAnalysisBloc bloc;
  late MockFetchDailyQuizForAnalysisUsecase
      mockFetchDailyQuizForAnalysisUsecase;

  setUp(() {
    mockFetchDailyQuizForAnalysisUsecase =
        MockFetchDailyQuizForAnalysisUsecase();
    bloc = FetchDailyQuizForAnalysisBloc(
        fetchDailyQuizForAnalysisUsecase: mockFetchDailyQuizForAnalysisUsecase);
  });

  const dailyQuiz = DailyQuiz(
      id: "id",
      description: "description",
      dailyQuizQuestions: [],
      userScore: 3);
  group('_onFetchDailyQuizForAnalysis', () {
    test('should get data from the fetch daily quiz for analysis usecase',
        () async {
      // arrange
      when(mockFetchDailyQuizForAnalysisUsecase(any))
          .thenAnswer((_) async => const Right(dailyQuiz));
      // act
      bloc.add(const FetchDailyQuizForAnalysisByIdEvent(id: "id"));

      await untilCalled(mockFetchDailyQuizForAnalysisUsecase(any));
      // assert
      verify(mockFetchDailyQuizForAnalysisUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockFetchDailyQuizForAnalysisUsecase(any))
          .thenAnswer((_) async => const Right(dailyQuiz));
      // assert later
      final expected = [
        FetchDailyQuizForAnalysisLoading(),
        const FetchDailyQuizForAnalysisLoaded(dailyQuiz: dailyQuiz)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuizForAnalysisByIdEvent(id: "id"));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockFetchDailyQuizForAnalysisUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        FetchDailyQuizForAnalysisLoading(),
         FetchDailyQuizForAnalysisFailed(errorMessage: "Server failure", failure: ServerFailure())
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuizForAnalysisByIdEvent(id: "id"));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockFetchDailyQuizForAnalysisUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        FetchDailyQuizForAnalysisLoading(),
         FetchDailyQuizForAnalysisFailed(errorMessage: "Cache failure", failure: CacheFailure())
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchDailyQuizForAnalysisByIdEvent(id: "id"));
    });
  });
}
