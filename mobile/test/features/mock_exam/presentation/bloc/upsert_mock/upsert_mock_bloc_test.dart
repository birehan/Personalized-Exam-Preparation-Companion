
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/mock_exam/mock_exam.dart';

import 'upsert_mock_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UpsertMockScoreUsecase>(),  
])


void main(){
  late UpsertMockScoreBloc bloc;
  late MockUpsertMockScoreUsecase mockUpsertMockScoreUsecase;


  setUp(() {
    mockUpsertMockScoreUsecase = MockUpsertMockScoreUsecase();
    bloc = UpsertMockScoreBloc(upsertMockScoreUsecase: mockUpsertMockScoreUsecase);
  });
  const tId = "test id";
  group('_onGetMockById', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockUpsertMockScoreUsecase(any))
          .thenAnswer((_) async =>  const Right(unit));
      // act
      bloc.add(const UpsertMyMockScoreEvent(mockId: tId, score: 5));

      await untilCalled(mockUpsertMockScoreUsecase(any));
      // assert
      verify(mockUpsertMockScoreUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockUpsertMockScoreUsecase(any))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const UpsertMyMockScoreState(status: MockExamStatus.loading),
        const UpsertMyMockScoreState(status: MockExamStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const UpsertMyMockScoreEvent(mockId: tId, score: 5));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockUpsertMockScoreUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const UpsertMyMockScoreState(status: MockExamStatus.loading),
        const UpsertMyMockScoreState(status: MockExamStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const UpsertMyMockScoreEvent(mockId: tId, score: 5));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockUpsertMockScoreUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const UpsertMyMockScoreState(status: MockExamStatus.loading),
        const UpsertMyMockScoreState(status: MockExamStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const UpsertMyMockScoreEvent(mockId: tId, score: 5));
    });
  });
  
}
