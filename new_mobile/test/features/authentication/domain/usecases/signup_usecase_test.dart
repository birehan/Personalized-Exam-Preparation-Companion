import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/entities/user_credential.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/usecases/signup_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late SignupUsecase signupUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    signupUsecase = SignupUsecase(repository: mockRepository);
  });

  group('SignupUsecase', () {
    test('should call the repository to perform signup', () async {
      // Arrange
      const params = SignupParams(
        emailOrPhoneNumber: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe',
        otp: '123456',
      );

      const userCredential = UserCredential(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
      );

      // Act
      when(mockRepository.signup(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
        password: anyNamed('password'),
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        otp: anyNamed('otp'),
      )).thenAnswer((_) async => const Right(userCredential));

      final result = await signupUsecase(params);

      // Assert
      expect(result, equals(const Right(userCredential))); 
      verify(mockRepository.signup(
        emailOrPhoneNumber: params.emailOrPhoneNumber,
        password: params.password,
        firstName: params.firstName,
        lastName: params.lastName,
        otp: params.otp,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
