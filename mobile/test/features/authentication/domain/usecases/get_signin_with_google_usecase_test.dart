import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/authentication/domain/usecases/get_signin_with_google_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late GetSignInWithGoogleUsecase getSignInWithGoogleUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    getSignInWithGoogleUsecase = GetSignInWithGoogleUsecase(repository: mockRepository);
  });

  group('GetSignInWithGoogleUsecase', () {
    test('should call the repository to check if signed in with Google', () async {
      // Arrange

      // Act
      when(mockRepository.isAuthenticatedWithGoogle()).thenAnswer((_) async =>const Right(true));

      final result = await getSignInWithGoogleUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(true))); 
      verify(mockRepository.isAuthenticatedWithGoogle());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
