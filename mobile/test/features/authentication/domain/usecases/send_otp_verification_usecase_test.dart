import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/usecases/send_otp_verification_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late SendOtpVerificationUsecase sendOtpVerificationUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    sendOtpVerificationUsecase = SendOtpVerificationUsecase(repository: mockRepository);
  });

  group('SendOtpVerificationUsecase', () {
    test('should call the repository to send OTP verification', () async {
      // Arrange
      const  params = SendOtpVerificationParams(emailOrPhoneNumber: 'test@example.com');

      // Act
      when(mockRepository.sendOtpVerification(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
      )).thenAnswer((_) async => const Right(unit));

      final result = await sendOtpVerificationUsecase(params);

      // Assert
      expect(result, equals(const Right(unit))); 
      verify(mockRepository.sendOtpVerification(
        emailOrPhoneNumber: params.emailOrPhoneNumber,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
