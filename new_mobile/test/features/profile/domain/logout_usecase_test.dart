import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/usecase/usecase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/logout_usecase.dart';

import 'get_profile_usecase_test.mocks.dart';

void main() {
  late ProfileLogoutUsecase usecase;
  late MockProfileRepositories mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepositories();
    usecase = ProfileLogoutUsecase(profileRepositories: mockProfileRepository);
  });

  test('should logout user', () async {
    // arrange
    when(mockProfileRepository.logout())
        .thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(true));
    verify(mockProfileRepository.logout());
    verifyNoMoreInteractions(mockProfileRepository);
  });
}
