
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/mock_exam/mock_exam.dart';

import 'my_mock_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetMyMocksUsecase>(),  
])

void main(){
  late MyMocksBloc bloc;
  late MockGetMyMocksUsecase mockExamByIdUsecase;


  setUp(() {
    mockExamByIdUsecase = MockGetMyMocksUsecase();
    bloc = MyMocksBloc(getMyMocksUsecase: mockExamByIdUsecase);
  });

  const userMock = [UserMock(id: "id", name: "name", numberOfQuestions: 20, departmentId: "departmentId", isCompleted: false, score: 2)];

  group('_onGetMockById', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async =>  const Right(userMock));
      // act
      bloc.add(const GetMyMocksEvent(isRefreshed: false));

      await untilCalled(mockExamByIdUsecase(any));
      // assert
      verify(mockExamByIdUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => const Right(userMock));
      // assert later
      final expected = [
        const GetMyMocksState(status: MyMocksStatus.loading),
        const GetMyMocksState(status: MyMocksStatus.loaded, userMocks: userMock)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMyMocksEvent(isRefreshed: false));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetMyMocksState(status: MyMocksStatus.loading),
        const GetMyMocksState(status: MyMocksStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMyMocksEvent(isRefreshed: false));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockExamByIdUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetMyMocksState(status: MyMocksStatus.loading),
        const GetMyMocksState(status: MyMocksStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMyMocksEvent(isRefreshed: false));
    });
  });
  
}