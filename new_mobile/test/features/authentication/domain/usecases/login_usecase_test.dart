import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/authentication/domain/entities/user_credential.dart';
import 'package:prep_genie/features/authentication/domain/usecases/login_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    loginUsecase = LoginUsecase(repository: mockRepository);
  });

  group('LoginUsecase', () {
    test('should call the repository to perform login', () async {
      // Arrange
      const params = LoginParams(
        emailOrPhoneNumber: 'test@example.com',
        password: 'password123',
        rememberMe: true,
      );

      const userCredential = UserCredential(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
      );

      // Act
      when(mockRepository.login(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
        password: anyNamed('password'),
        rememberMe: anyNamed('rememberMe'),
      )).thenAnswer((_) async => const Right(userCredential));

      final result = await loginUsecase(params);

      // Assert
      expect(result, equals(const Right(userCredential)));
      verify(mockRepository.login(
        emailOrPhoneNumber: params.emailOrPhoneNumber,
        password: params.password,
        rememberMe: params.rememberMe,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
