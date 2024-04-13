import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/mock_exam/domain/entities/mock.dart';

import 'get_profile_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProfileRepositories>(),
])
void main() {
  late GetProfileUsecase usecase;
  late MockProfileRepositories mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepositories();
    usecase = GetProfileUsecase(profileRepositories: mockProfileRepository);
  });

  const userProfile = UserProfile(
      firstName: 'abe',
      lastName: 'kebe',
      email: 'abekebe@gmail.com',
      profileImage: 'profileImage',
      topicsCompleted: 1,
      chaptersCompleted: 1,
      questionsSolved: 1,
      totalScore: 10,
      rank: 100,
      points: 200,
      currentStreak: 3,
      maxStreak: 3,
      consistecy: [],
      examType: 'examType',
      howPrepared: 'howPrepared',
      preferedMethod: 'preferedMethod',
      studyTimePerDay: 'studyTimePerDay',
      motivation: 'motivation',
      reminder: 'reminder',
      departmentId: 'departmentId',
      departmentName: 'departmentName');

  test('should get user profile from repository', () async {
    // Arrange
    when(mockProfileRepository.getUserProfile(
            isRefreshed: anyNamed('isRefreshed'), userId: anyNamed('userId')))
        .thenAnswer((_) async => const Right(userProfile));

    // Act
    final result = await usecase(
      GetUserProfileParams(isRefreshed: true, userId: '123'),
    );

    // Assert
    expect(result, const Right(userProfile));

    verify(mockProfileRepository.getUserProfile(
      isRefreshed: true,
      userId: '123',
    ));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  // test('should return failure on repository error', () async {
  //   // Arrange
  //   when(mockProfileRepository.getUserProfile(
  //           isRefreshed: false, userId: '123'))
  //       .thenAnswer((_) async => Left(CacheFailure()));

  //   // Act
  //   final result = await usecase(GetUserProfileParams(isRefreshed: false));

  //   // Assert
  //   expect(result, Left(isA<CacheFailure>()));
  // });
}
