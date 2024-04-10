import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/usecases/change_password_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])

void main() {
  late ChangePasswordUsecase changePasswordUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    changePasswordUsecase = ChangePasswordUsecase(repository: mockRepository);
  });

  group('ChangePasswordUsecase', () {
    test('should call the repository to change password', () async {
      // Arrange
      const params = ChangePasswordParams(
        emailOrPhoneNumber: 'test@example.com',
        newPassword: 'newPassword123',
        confirmPassword: 'newPassword123',
        otp: '123456',
      );

      // Act
      when(mockRepository.changePassword(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
        newPassword: anyNamed('newPassword'),
        confirmPassword: anyNamed('confirmPassword'),
        otp: anyNamed('otp'),
      )).thenAnswer((_) async => const Right(unit));

      final result = await changePasswordUsecase(params);

      // Assert
      expect(result, equals(const Right(unit))); 
      verify(mockRepository.changePassword(
        emailOrPhoneNumber: params.emailOrPhoneNumber,
        newPassword: params.newPassword,
        confirmPassword: params.confirmPassword,
        otp: params.otp,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

