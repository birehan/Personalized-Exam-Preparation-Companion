import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/authentication/domain/usecases/initialize_app_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

void main() {
  late InitializeAppUsecase initializeAppUsecase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    initializeAppUsecase = InitializeAppUsecase(repository: mockRepository);
  });

  group('InitializeAppUsecase', () {
    test('should call the repository to initialize the app', () async {
      // Arrange

      // Act
      when(mockRepository.initializeApp())
          .thenAnswer((_) async => const Right(unit));

      final result = await initializeAppUsecase(NoParams());

      // Assert
      expect(result, equals(const Right(unit)));
      verify(mockRepository.initializeApp());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
