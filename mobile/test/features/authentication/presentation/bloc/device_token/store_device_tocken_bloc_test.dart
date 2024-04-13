import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';

import 'store_device_tocken_bloc_test.mocks.dart';



@GenerateNiceMocks([
  MockSpec<StoreDeviceTokenUsecase>() 
])

void main() {
  late StoreDeviceTokenBloc bloc;
  late MockStoreDeviceTokenUsecase storeDeviceTokenUsecase;

  setUp(() {
    storeDeviceTokenUsecase = MockStoreDeviceTokenUsecase();
    bloc = StoreDeviceTokenBloc(storeDeviceTokenUsecase: storeDeviceTokenUsecase);
  });

  group('_storeDeviceToken', () {
    test('should get data from store device token bloc', () async {
      // arrange
      when(storeDeviceTokenUsecase(NoParams()))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(const StoreDeviceTokenEvent());

      await untilCalled(storeDeviceTokenUsecase(NoParams()));
      // assert
      verify(storeDeviceTokenUsecase(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(storeDeviceTokenUsecase(NoParams()))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        StoreDeviceTokenLoading(),
         StoreDeviceTokenLoaded()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const StoreDeviceTokenEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(storeDeviceTokenUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [StoreDeviceTokenLoading(), const StoreDeviceTokenFailed(message: "Server failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const StoreDeviceTokenEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(storeDeviceTokenUsecase(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [StoreDeviceTokenLoading(), const StoreDeviceTokenFailed(message: "Cache failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const StoreDeviceTokenEvent());
    });
  });
}