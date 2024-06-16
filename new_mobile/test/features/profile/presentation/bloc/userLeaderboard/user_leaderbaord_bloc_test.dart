import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/features/profile/domain/entities/leaderboard.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_rank.dart';
import 'package:prep_genie/features/profile/domain/usecases/get_top_users_usecase.dart';
import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';

import 'user_leaderbaord_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetTopUsersUsecase>()])
void main() {
  late MockGetTopUsersUsecase mockGetTopUsers;

  setUp(() {
    mockGetTopUsers = MockGetTopUsersUsecase();
  });
  final userLeaderboardFirstTimeCalledList = [
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
  final userLeaderboardCumulativeList = [
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
  final userLeaderboardAfterFirstTimeCalledList = [
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
  final expectedLeaderboardOnFirstCall = Leaderboard(
    userLeaderboardEntities: userLeaderboardFirstTimeCalledList,
    userRank: userLederboardRank,
  );
  final leaderboardAfterFirstCall = Leaderboard(
    userLeaderboardEntities: userLeaderboardAfterFirstTimeCalledList,
    userRank: userLederboardRank,
  );
  final expectedleaderboardCumulative = Leaderboard(
    userLeaderboardEntities: userLeaderboardCumulativeList,
    userRank: userLederboardRank,
  );
  blocTest<UsersLeaderboardBloc, UsersLeaderboardState>(
    'emits [SchoolLoadingState, UsersLeaderboardLoadedState] GetTopUsersEvent when  called for first page',
    build: () => UsersLeaderboardBloc(getTopUsersUsecase: mockGetTopUsers),
    act: (bloc) => bloc.add(const GetTopUsersEvent(
        pageNumber: 1, leaderboardType: LeaderboardType.allTime)),
    setUp: () => when(mockGetTopUsers(any))
        .thenAnswer((_) async => Right(expectedLeaderboardOnFirstCall)),
    expect: () => [
      UsersLeaderboardLoadingState(),
      UsersLeaderboardLoadedState(topUsers: expectedLeaderboardOnFirstCall),
    ],
    verify: (_) {
      verify(mockGetTopUsers(any)).called(1);
    },
  );
  blocTest<UsersLeaderboardBloc, UsersLeaderboardState>(
    'emits [SchoolLoadingState, UsersLeaderboardLoadedState] GetTopUsersEvent when called after the first page',
    build: () => UsersLeaderboardBloc(getTopUsersUsecase: mockGetTopUsers),
    act: (bloc) => bloc.add(const GetTopUsersEvent(
        pageNumber: 2, leaderboardType: LeaderboardType.allTime)),
    seed: () =>
        UsersLeaderboardLoadedState(topUsers: expectedLeaderboardOnFirstCall),
    setUp: () => when(mockGetTopUsers(any))
        .thenAnswer((_) async => Right(leaderboardAfterFirstCall)),
    expect: () => [
      UsersLeaderboardNextPageLoadingState(
          previousLeaderboard: expectedLeaderboardOnFirstCall),
      UsersLeaderboardLoadedState(topUsers: expectedleaderboardCumulative),
    ],
    verify: (_) {
      verify(mockGetTopUsers(any)).called(1);
    },
  );
  blocTest<UsersLeaderboardBloc, UsersLeaderboardState>(
    'emits [SchoolLoadingState, UsersLeaderboardFailedState] GetTopUsersEvent returened error',
    build: () => UsersLeaderboardBloc(getTopUsersUsecase: mockGetTopUsers),
    act: (bloc) => bloc.add(const GetTopUsersEvent(
        pageNumber: 1, leaderboardType: LeaderboardType.allTime)),
    setUp: () => when(mockGetTopUsers(any))
        .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error'))),
    expect: () => [
      UsersLeaderboardLoadingState(),
      UsersLeaderboardFailedState(
          failure: ServerFailure(), errorMessage: 'error'),
    ],
    verify: (_) {
      verify(mockGetTopUsers(any)).called(1);
    },
  );
}
