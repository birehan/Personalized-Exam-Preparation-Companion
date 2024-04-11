import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/authentication/data/models/user_credential_model.dart';
import 'package:prepgenie/features/authentication/domain/usecases/get_user_credential_usecase.dart';
import 'package:prepgenie/features/authentication/presentation/bloc/get_user_bloc/get_user_bloc.dart';

import 'get_user_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetUserCredentialUsecase>()])
void main() {
  late GetUserBloc bloc;
  late MockGetUserCredentialUsecase getUserCredentialUsecase;

  setUp(() {
    getUserCredentialUsecase = MockGetUserCredentialUsecase();
    bloc = GetUserBloc(getUserCredentialUsecase: getUserCredentialUsecase);
  });
  const validEmail = 'test@example.com';
  const validFirstName = 'John';
  const validLastName = 'Doe';
  const userCredential = UserCredentialModel(
      id: "1",
      email: validEmail,
      firstName: validFirstName,
      lastName: validLastName);
  group('_onGetUserCredential', () {
    test('should get data from user credential usecase', () async {
      // arrange
      when(getUserCredentialUsecase(NoParams()))
          .thenAnswer((_) async => const Right(userCredential));
      // act
      bloc.add(GetUserCredentialEvent());

      await untilCalled(getUserCredentialUsecase(NoParams()));
      // assert
      verify(getUserCredentialUsecase(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(getUserCredentialUsecase(NoParams()))
          .thenAnswer((_) async => const Right(userCredential));
      // assert later
      final expected = [
        const GetUserCredentialState(status: GetUserStatus.loading),
        const GetUserCredentialState(status: GetUserStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetUserCredentialEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(getUserCredentialUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetUserCredentialState(status: GetUserStatus.loading),
        const GetUserCredentialState(status: GetUserStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetUserCredentialEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(getUserCredentialUsecase(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetUserCredentialState(status: GetUserStatus.loading),
        const GetUserCredentialState(status: GetUserStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetUserCredentialEvent());
    });
  });
}
