import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/usecases/store_device_token_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late StoreDeviceTokenUsecase storeDeviceTokenUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    storeDeviceTokenUsecase = StoreDeviceTokenUsecase(repository: mockRepository);
  });

  group('StoreDeviceTokenUsecase', () {
    test('should call the repository to store device token', () async {
      // Arrange

      // Act
      when(mockRepository.storeDeviceToken()).thenAnswer((_) async => const Right(unit));

      final result = await storeDeviceTokenUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(unit))); 
      verify(mockRepository.storeDeviceToken());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
