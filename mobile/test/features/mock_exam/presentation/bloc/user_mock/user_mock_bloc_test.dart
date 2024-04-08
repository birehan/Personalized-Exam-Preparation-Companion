
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/mock_exam/mock_exam.dart';

import 'user_mock_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AddMockToUserMocksUsecase>(),  
])

void main(){
  late UserMockBloc bloc;
  late MockAddMockToUserMocksUsecase mockUpsertMockScoreUsecase;


  setUp(() {
    mockUpsertMockScoreUsecase = MockAddMockToUserMocksUsecase();
    bloc = UserMockBloc(addMockToUserMocksUsecase: mockUpsertMockScoreUsecase);
  });
  const tId = "test id";
  group('_onRegisterMock', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockUpsertMockScoreUsecase(any))
          .thenAnswer((_) async =>  const Right(unit));
      // act
      bloc.add(const AddMockToUserMockEvent(mockId: tId));

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
        const AddMocktoUserMockState(status: UserMockStatus.loading),
        const AddMocktoUserMockState(status: UserMockStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const AddMockToUserMockEvent(mockId: tId));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockUpsertMockScoreUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const AddMocktoUserMockState(status: UserMockStatus.loading),
        const AddMocktoUserMockState(status: UserMockStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const AddMockToUserMockEvent(mockId: tId));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockUpsertMockScoreUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const AddMocktoUserMockState(status: UserMockStatus.loading),
        const AddMocktoUserMockState(status: UserMockStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const AddMockToUserMockEvent(mockId: tId));
    });
  });
  
}
