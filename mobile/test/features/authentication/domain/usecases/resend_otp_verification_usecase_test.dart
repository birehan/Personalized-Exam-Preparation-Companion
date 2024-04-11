import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/authentication/domain/usecases/resend_otp_verification_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late ResendOtpVerificationUsecase resendOtpVerificationUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    resendOtpVerificationUsecase = ResendOtpVerificationUsecase(repository: mockRepository);
  });

  group('ResendOtpVerificationUsecase', () {
    test('should call the repository to resend OTP verification', () async {
      // Arrange
      const params = ResendOtpVerificationParams(emailOrPhoneNumber: 'test@example.com');

      // Act
      when(mockRepository.resendOtpVerification(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
      )).thenAnswer((_) async => const Right(unit));

      final result = await resendOtpVerificationUsecase(params);

      // Assert
      expect(result, equals(const Right(unit)));
      verify(mockRepository.resendOtpVerification(
        emailOrPhoneNumber: params.emailOrPhoneNumber,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
