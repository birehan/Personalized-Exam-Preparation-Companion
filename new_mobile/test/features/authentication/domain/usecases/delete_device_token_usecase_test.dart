import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/authentication/domain/usecases/delete_device_token_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late DeleteDeviceTokenUsecase deleteDeviceTokenUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    deleteDeviceTokenUsecase =
        DeleteDeviceTokenUsecase(repository: mockRepository);
  });

  group('DeleteDeviceTokenUsecase', () {
    test('should call the repository to delete device token', () async {
      // Arrange

      // Act
      when(mockRepository.deleteDeviceToken())
          .thenAnswer((_) async => const Right(unit));

      final result = await deleteDeviceTokenUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(unit)));
      verify(mockRepository.deleteDeviceToken());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
