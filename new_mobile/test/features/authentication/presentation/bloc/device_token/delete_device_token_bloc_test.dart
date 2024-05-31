import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'delete_device_token_bloc_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<DeleteDeviceTokenUsecase>() 
])

void main() {
  late DeleteDeviceTokenBloc bloc;
  late DeleteDeviceTokenUsecase deleteDeviceTokenUsecase;

  setUp(() {
    deleteDeviceTokenUsecase = MockDeleteDeviceTokenUsecase();
    bloc = DeleteDeviceTokenBloc(deleteDeviceTokenUsecase: deleteDeviceTokenUsecase);
  });

  group('_deleteDeviceToken', () {
    test('should get data from delete device token bloc', () async {
      // arrange
      when(deleteDeviceTokenUsecase(NoParams()))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(const DeleteDeviceTokenEvent());

      await untilCalled(deleteDeviceTokenUsecase(NoParams()));
      // assert
      verify(deleteDeviceTokenUsecase(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(deleteDeviceTokenUsecase(NoParams()))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        DeleteDeviceTokenLoading(),
         DeleteDeviceTokenLoaded()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const DeleteDeviceTokenEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(deleteDeviceTokenUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [DeleteDeviceTokenLoading(), const DeleteDeviceTokenFailed(message: "Server failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const DeleteDeviceTokenEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(deleteDeviceTokenUsecase(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [DeleteDeviceTokenLoading(), const DeleteDeviceTokenFailed(message: "Cache failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const DeleteDeviceTokenEvent());
    });
  });
}