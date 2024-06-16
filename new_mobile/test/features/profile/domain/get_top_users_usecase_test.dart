import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/profile/domain/entities/leaderboard.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';
import 'package:prep_genie/features/profile/domain/usecases/get_top_users_usecase.dart';
import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';

import 'get_profile_usecase_test.mocks.dart';

void main() {
  late GetTopUsersUsecase usecase;
  late MockProfileRepositories mockProfileRepositories;

  setUp(() {
    mockProfileRepositories = MockProfileRepositories();
    usecase = GetTopUsersUsecase(profileRepositories: mockProfileRepositories);
  });

  test('should return leaderboard from repository', () async {
    // arrange
    final userLeaderboardEntityList = [
      const UserLeaderboardEntity(
          firstName: 'firstName',
          overallRank: 32,
          overallPoints: 32,
          userAvatar: 'userAvatar',
          lastName: 'lastName',
          maxStreak: 2,
          contestAttended: 2,
          userId: '123'),
      const UserLeaderboardEntity(
          firstName: 'firstName',
          overallRank: 32,
          overallPoints: 32,
          userAvatar: 'userAvatar',
          lastName: 'lastName',
          maxStreak: 2,
          contestAttended: 2,
          userId: '123'),
      const UserLeaderboardEntity(
          firstName: 'firstName',
          overallRank: 32,
          overallPoints: 32,
          userAvatar: 'userAvatar',
          lastName: 'lastName',
          maxStreak: 2,
          contestAttended: 2,
          userId: '123'),
    ];

    const userLederboardRank = UserLeaderboardRank(
        id: '111',
        rank: 2,
        avatar: 'avatar',
        firstName: 'firstName',
        lastName: 'lastName',
        points: 23,
        maxStreak: 2,
        contestAttended: 2);
    final expectedLeaderboard = Leaderboard(
      userLeaderboardEntities: userLeaderboardEntityList,
      userRank: userLederboardRank,
    );

    when(mockProfileRepositories.getTopUsers(
            page: 1, leaderboardtype: LeaderboardType.allTime))
        .thenAnswer((_) async => Right(expectedLeaderboard));

    // act
    final result = await usecase(
      LeaderboardParams(page: 1, leaderboardType: LeaderboardType.allTime),
    );

    // assert
    expect(result, Right(expectedLeaderboard));
    verify(mockProfileRepositories.getTopUsers(
        page: 1, leaderboardtype: LeaderboardType.allTime));
    verifyNoMoreInteractions(mockProfileRepositories);
  });

  // test('should return Failure on error from repository', () async {
  //   // arrange
  //   when(mockProfileRepositories.getTopUsers(page: anyNamed('page')))
  //       .thenAnswer((_) async => Left(CacheFailure()));

  //   // act
  //   final result = await usecase(
  //     LeaderboardParams(page: 1),
  //   );

  //   // assert
  //   expect(result, Left(isA<CacheFailure>()));
  //   verify(mockProfileRepositories.getTopUsers(page: 1));
  //   verifyNoMoreInteractions(mockProfileRepositories);
  // });
}
