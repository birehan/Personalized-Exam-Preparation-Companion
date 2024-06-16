import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/authentication/domain/entities/user_credential.dart';
import 'package:prep_genie/features/authentication/domain/usecases/get_user_credential_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late GetUserCredentialUsecase getUserCredentialUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    getUserCredentialUsecase =
        GetUserCredentialUsecase(repository: mockRepository);
  });

  group('GetUserCredentialUsecase', () {
    test('should call the repository to get user credentials', () async {
      // Arrange
      const userCredential = UserCredential(
        id: '1',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        school: 'Some School',
        grade: 12,
      );

      // Act
      when(mockRepository.getUserCredential())
          .thenAnswer((_) async => const Right(userCredential));

      final result = await getUserCredentialUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(userCredential)));
      verify(mockRepository.getUserCredential());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
