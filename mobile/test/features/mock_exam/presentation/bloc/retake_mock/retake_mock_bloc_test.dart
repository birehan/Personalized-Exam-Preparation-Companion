import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/mock_exam/mock_exam.dart';

import 'retake_mock_bloc_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<RetakeMockUsecase>(),  
])


void main(){
  late RetakeMockBloc bloc;
  late MockRetakeMockUsecase mockRetakeMockUsecase;


  setUp(() {
    mockRetakeMockUsecase = MockRetakeMockUsecase();
    bloc = RetakeMockBloc(retakeMockUsecase: mockRetakeMockUsecase);
  });
  const tId = "test id";
  group('_onGetMockById', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockRetakeMockUsecase(any))
          .thenAnswer((_) async =>  const Right(unit));
      // act
      bloc.add(const RetakeMockEvent(mockId: tId));

      await untilCalled(mockRetakeMockUsecase(any));
      // assert
      verify(mockRetakeMockUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockRetakeMockUsecase(any))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        RetakeMockLoading(),
        RetakeMockLoaded()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const RetakeMockEvent(mockId: tId));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockRetakeMockUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        RetakeMockLoading(),
        const RetakeMockFailed(errorMessage: "Server failure" )
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const RetakeMockEvent(mockId: tId));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockRetakeMockUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        RetakeMockLoading(),
        const RetakeMockFailed(errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const RetakeMockEvent(mockId: tId));
    });
  });
  
}
