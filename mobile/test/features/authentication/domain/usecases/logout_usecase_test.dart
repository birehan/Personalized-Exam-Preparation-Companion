import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/authentication/domain/usecases/logout_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late LogoutUsecase logoutUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    logoutUsecase = LogoutUsecase(repository: mockRepository);
  });

  group('LogoutUsecase', () {
    test('should call the repository to perform logout', () async {
      // Arrange

      // Act
      when(mockRepository.logout()).thenAnswer((_) async => const Right(unit));

      final result = await logoutUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(unit))); 
      verify(mockRepository.logout());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
