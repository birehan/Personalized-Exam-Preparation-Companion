import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/authentication/domain/usecases/logout_with_google_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late SignOutWithGoogleUsecase signOutWithGoogleUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    signOutWithGoogleUsecase = SignOutWithGoogleUsecase(repository: mockRepository);
  });

  group('SignOutWithGoogleUsecase', () {
    test('should call the repository to sign out with Google', () async {
      // Arrange

      // Act
      when(mockRepository.logoutWithGoogle()).thenAnswer((_) async => const Right(unit));

      final result = await signOutWithGoogleUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(unit))); 
      verify(mockRepository.logoutWithGoogle());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
