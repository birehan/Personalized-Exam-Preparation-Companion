import 'package:mockito/annotations.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';

import 'submit_daily_quest_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubmitDailyQuizAnswerUsecase>()])
void main() {
  late SubmitDailyQuizAnswerBloc bloc;
  late MockSubmitDailyQuizAnswerUsecase mockSubmitDailyQuizAnswerUsecase;

  setUp(() {
    mockSubmitDailyQuizAnswerUsecase = MockSubmitDailyQuizAnswerUsecase();
    bloc = SubmitDailyQuizAnswerBloc(
        submitDailyQuizAnswerUsecase: mockSubmitDailyQuizAnswerUsecase);
  });

  const userAnswer = [
    DailyQuizUserAnswer(questionId: "questionId", userAnswer: "userAnswer")
  ];
  const dailyQuizAnswer =
      DailyQuizAnswer(dailyQuizId: "dailyQuizId", userAnswer: userAnswer);

  group('_onSubmitDailyQuizAnswer', () {
    test('should get data from the submit daily quiz for analysis usecase',
        () async {
      // arrange
      when(mockSubmitDailyQuizAnswerUsecase(any))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(
          const SubmitDailyQuizAnswerEvent(dailyQuizAnswer: dailyQuizAnswer));

      await untilCalled(mockSubmitDailyQuizAnswerUsecase(any));
      // assert
      verify(mockSubmitDailyQuizAnswerUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockSubmitDailyQuizAnswerUsecase(any))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        SubmitDailyQuizAnswerLoading(),
        SubmitDailyQuizAnswerLoaded()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
          const SubmitDailyQuizAnswerEvent(dailyQuizAnswer: dailyQuizAnswer));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockSubmitDailyQuizAnswerUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        SubmitDailyQuizAnswerLoading(),
        const SubmitDailyQuizAnswerFailed(errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
          const SubmitDailyQuizAnswerEvent(dailyQuizAnswer: dailyQuizAnswer));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockSubmitDailyQuizAnswerUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        SubmitDailyQuizAnswerLoading(),
        const SubmitDailyQuizAnswerFailed(errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
          const SubmitDailyQuizAnswerEvent(dailyQuizAnswer: dailyQuizAnswer));
    });
  });
}
