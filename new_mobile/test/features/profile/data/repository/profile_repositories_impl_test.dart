// import 'dart:ffi';

// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:prep_genie/core/core.dart';
// import 'package:prep_genie/core/error/exception.dart';
// import 'package:prep_genie/core/error/failure.dart';
// import 'package:prep_genie/core/network/network.dart';
// import 'package:prep_genie/core/utils/hive_boxes.dart';
// import 'package:prep_genie/features/authentication/authentication.dart';
// import 'package:prep_genie/features/features.dart';
// import 'package:prep_genie/features/mock_exam/mock_exam.dart';
// import 'package:prep_genie/features/profile/data/models/user_profile_model.dart';
// import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';
// import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';

// import 'profile_repositories_impl_test.mocks.dart';

// @GenerateNiceMocks([
//   MockSpec<ProfileRemoteDataSource>(),
//   MockSpec<NetworkInfo>(),
//   MockSpec<ProfileLocalDataSource>(),
//   MockSpec<HiveBoxes>(),
// ])
// void main() {
//   late ProfileRepositoryImpl repositoryImpl;
//   late MockProfileRemoteDataSource mockProfileRemoteDataSource;
//   late MockProfileLocalDataSource mockProfileLocalDataSource;
//   late MockNetworkInfo mockNetworkInfo;
//   late MockHiveBoxes mockHiveBoxes;
//   late HiveBoxes hiveBox;
//   late NetworkInfo networkInfo;

//   setUp(() {
//     mockProfileRemoteDataSource = MockProfileRemoteDataSource();
//     mockProfileLocalDataSource = MockProfileLocalDataSource();
//     mockNetworkInfo = MockNetworkInfo();
//     mockHiveBoxes = MockHiveBoxes();
//     hiveBox = HiveBoxes();
//     networkInfo = NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker());
//     reset(mockProfileRemoteDataSource);
//     reset(mockNetworkInfo);
//     repositoryImpl = ProfileRepositoryImpl(
//       hiveBoxes: hiveBox,
//       profileRemoteDataSource: mockProfileRemoteDataSource,
//       profileLocalDataSource: mockProfileLocalDataSource,
//       networkInfo: networkInfo,
//     );
//   });

//   void runTestsOnline(Function body) {
//     group('device is online', () {
//       setUp(() {
//         when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
//       });
//       body();
//     });
//   }

//   void runTestOffline(Function body) {
//     group('device is offline', () {
//       setUp(() {
//         when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
//       });
//       body();
//     });
//   }

//   group('getUserProfile', () {
//     int coins = 0;
//     final tUserProfile = UserProfileModel(
//       coins: coins,
//       id: 'id',
//       firstName: 'abe',
//       lastName: 'kebe',
//       email: 'abekebe@gmail.com',
//       profileImage: 'profileImage',
//       topicsCompleted: 1,
//       chaptersCompleted: 1,
//       questionsSolved: 1,
//       totalScore: 10,
//       rank: 100,
//       points: 200,
//       currentStreak: 3,
//       maxStreak: 3,
//       consistecy: [],
//       examType: 'examType',
//       howPrepared: 'howPrepared',
//       preferedMethod: 'preferedMethod',
//       studyTimePerDay: 'studyTimePerDay',
//       motivation: 'motivation',
//       reminder: 'reminder',
//       departmentId: 'departmentId',
//       departmentName: 'departmentName',
//     );

//     group('getUserCourse', () {
//       test('should check if the device is online', () async {
//         // arrange
//         when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
//         // act
//         await repositoryImpl.getUserProfile(isRefreshed: true);
//         // assert
//         verify(mockNetworkInfo.isConnected);
//       });
//       runTestsOnline(() {
//         test(
//             'should return user profile when the getUserProfile call to remote data source is successful',
//             () async {
//           // arrange
//           when(mockProfileRemoteDataSource.getUserProfile())
//               .thenAnswer((_) async => tUserProfile);
//           // act
//           final result = await repositoryImpl.getUserProfile(isRefreshed: true);
//           // assert
//           verifyNever(mockProfileRemoteDataSource.getUserProfile());
//           expect(result, equals(Right(tUserProfile)));
//         });
//       });

//       test(
//           'should return cache the userProfile when the getUserProfile call to remote data source is successful',
//           () async {
//         // arrange
//         when(mockProfileRemoteDataSource.getUserProfile())
//             .thenAnswer((_) async => tUserProfile);
//         // act
//         await repositoryImpl.getUserProfile(isRefreshed: false);
//         // assert
//         verifyNever(mockProfileRemoteDataSource);
//       });
//     });
//   });

//   // test logout
//   group('logout', () {
//     test('should check if the device is online', () async {
//       // arrange
//       when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
//       // act
//       await repositoryImpl.logout();
//       // assert
//       verifyNever(mockNetworkInfo.isConnected);
//     });
//     runTestsOnline(() {
//       test('should return true when logout called', () async {
//         // arrange
//         when(mockProfileRemoteDataSource.logout())
//             .thenAnswer((_) async => true);
//         // when(AuthenticationWithGoogle.signOut).thenAnswer((_) async => null);
//         when(mockProfileLocalDataSource.logout()).thenAnswer((_) async => true);

//         // act
//         final result = await repositoryImpl.logout();

//         // assert
//         verify(mockProfileRemoteDataSource.logout());
//         verify(mockProfileLocalDataSource.logout()).called(1);
//         verify(mockHiveBoxes.clearHiveBoxes()).called(1);
//         expect(result, const Right(true));
//       });
//     });
//   });

//   // test leaderboard

//   group('getTopUsers', () {
//     final userLeaderboardEntityList = [
//       const UserLeaderboardEntity(
//           firstName: 'firstName',
//           overallRank: 32,
//           overallPoints: 32,
//           userAvatar: 'userAvatar',
//           lastName: 'lastName',
//           maxStreak: 2,
//           contestAttended: 2,
//           userId: '123'),
//       const UserLeaderboardEntity(
//           firstName: 'firstName',
//           overallRank: 32,
//           overallPoints: 32,
//           userAvatar: 'userAvatar',
//           lastName: 'lastName',
//           maxStreak: 2,
//           contestAttended: 2,
//           userId: '123'),
//       const UserLeaderboardEntity(
//           firstName: 'firstName',
//           overallRank: 32,
//           overallPoints: 32,
//           userAvatar: 'userAvatar',
//           lastName: 'lastName',
//           maxStreak: 2,
//           contestAttended: 2,
//           userId: '123'),
//     ];

//     const userLederboardRank = UserLeaderboardRank(
//         id: '111',
//         rank: 2,
//         avatar: 'avatar',
//         firstName: 'firstName',
//         lastName: 'lastName',
//         points: 23,
//         maxStreak: 2,
//         contestAttended: 2);
//     final expectedLeaderboard = LeaderboardModel(
//       userLeaderboardEntities: userLeaderboardEntityList,
//       userRank: userLederboardRank,
//     );
//     // group('getTopUsers', () {
//     //   test('should check if the device is online', () async {
//     //     // arrange
//     //     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
//     //     // act
//     //     await repositoryImpl.getTopUsers(
//     //         page: 1, leaderboardtype: LeaderboardType.allTime);
//     //     // assert
//     //     verify(mockNetworkInfo.isConnected);
//     //   });
//     //   runTestsOnline(() {
//     //     test(
//     //         'should return leaderboard when the getTopUsers call to remote data source is successful',
//     //         () async {
//     //       // arrange
//     //       when(mockProfileRemoteDataSource.getTopUsers(
//     //               page: 1, leaderboardType: LeaderboardType.allTime))
//     //           .thenAnswer((_) async => expectedLeaderboard);
//     //       // act
//     //       final result = await repositoryImpl.getUserProfile(isRefreshed: true);
//     //       // assert
//     //       verify(mockProfileRemoteDataSource.getUserProfile());
//     //       expect(result, equals(Left(expectedLeaderboard)));
//     //     });
//     //   });

//       // test(
//       //     'should return cache the userProfile when the getUserProfile call to remote data source is successful',
//       //     () async {
//       //   // arrange
//       //   when(mockProfileRemoteDataSource.getTopUsers(page: 1))
//       //       .thenAnswer((_) async => expectedLeaderboard);
//       //   // act
//       //   await repositoryImpl.getUserProfile(isRefreshed: false);
//       //   // assert
//       //   verifyNoMoreInteractions(mockProfileRemoteDataSource);
//       // });
//     // });
//   });
// }

import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/core/error/exception.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/core/network/network.dart';
import 'package:prep_genie/core/utils/hive_boxes.dart';
import 'package:prep_genie/features/authentication/authentication.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/mock_exam/mock_exam.dart';
import 'package:prep_genie/features/profile/data/models/user_profile_model.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';
import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';

import 'profile_repositories_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProfileRemoteDataSource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<ProfileLocalDataSource>(),
  MockSpec<HiveBoxes>(),
])
void main() {
  late ProfileRepositoryImpl repositoryImpl;
  late MockProfileRemoteDataSource mockProfileRemoteDataSource;
  late MockProfileLocalDataSource mockProfileLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockHiveBoxes mockHiveBoxes;
  late HiveBoxes hiveBox;
  late NetworkInfo networkInfo;

  setUp(() {
    mockProfileRemoteDataSource = MockProfileRemoteDataSource();
    mockProfileLocalDataSource = MockProfileLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockHiveBoxes = MockHiveBoxes();
    hiveBox = HiveBoxes();
    networkInfo =
        NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker());
    reset(mockProfileRemoteDataSource);
    reset(mockNetworkInfo);
    repositoryImpl = ProfileRepositoryImpl(
      hiveBoxes: hiveBox,
      profileRemoteDataSource: mockProfileRemoteDataSource,
      profileLocalDataSource: mockProfileLocalDataSource,
      networkInfo: networkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getUserProfile', () {
    int coins = 0;
    final tUserProfile = UserProfileModel(
      coins: coins,
      id: 'id',
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
      departmentName: 'departmentName',
    );
  });
}
