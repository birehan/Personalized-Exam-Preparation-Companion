import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/entities/user_credential.dart';
import 'package:skill_bridge_mobile/features/authentication/domain/usecases/login_with_google_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late SignInWithGoogleUsecase signInWithGoogleUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    signInWithGoogleUsecase =
        SignInWithGoogleUsecase(repository: mockRepository);
  });
  const userCredential = UserCredential(
    id: '1',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
  );
  group('SignInWithGoogleUsecase', () {
    test('should call the repository to sign in with Google', () async {
      // Arrange

      // Act
      when(mockRepository.signInWithGoogle())
          .thenAnswer((_) async => const Right(userCredential));

      final result = await signInWithGoogleUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(userCredential)));
      verify(mockRepository.signInWithGoogle());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
