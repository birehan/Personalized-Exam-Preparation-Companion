import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/authentication/domain/usecases/get_app_initialization_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late GetAppInitializationUsecase getAppInitializationUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    getAppInitializationUsecase = GetAppInitializationUsecase(repository: mockRepository);
  });

  group('GetAppInitializationUsecase', () {
    test('should call the repository to get app initialization status', () async {
      // Arrange

      // Act
      when(mockRepository.getAppInitialization()).thenAnswer((_) async =>const Right(true));

      final result = await getAppInitializationUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(true)));
      verify(mockRepository.getAppInitialization());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
