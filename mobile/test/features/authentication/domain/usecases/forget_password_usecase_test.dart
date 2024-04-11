import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/authentication/domain/usecases/forget_password_usecase.dart';

import 'change_password_usecase_test.mocks.dart';


void main() {
  late ForgetPasswordUsecase forgetPasswordUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    forgetPasswordUsecase = ForgetPasswordUsecase(repository: mockRepository);
  });

  group('ForgetPasswordUsecase', () {
    test('should call the repository to initiate forget password', () async {
      // Arrange
      const params = ForgetPasswordParams(
        emailOrPhoneNumber: 'test@example.com',
        otp: '123456',
      );

      // Act
      when(mockRepository.forgetPassword(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
        otp: anyNamed('otp'),
      )).thenAnswer((_) async => const Right(unit));

      final result = await forgetPasswordUsecase(params);

      // Assert
      expect(result, equals(const Right(unit))); 
      verify(mockRepository.forgetPassword(
        emailOrPhoneNumber: params.emailOrPhoneNumber,
        otp: params.otp,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
