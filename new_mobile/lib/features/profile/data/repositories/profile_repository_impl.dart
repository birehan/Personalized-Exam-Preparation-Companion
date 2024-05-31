import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/utils/hive_boxes.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/all_barchart_categories_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/profile_update_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_info_enitity.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import '../../../features.dart';
import '../../../../core/core.dart';

class ProfileRepositoryImpl implements ProfileRepositories {
  final NetworkInfo networkInfo;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profileLocalDataSource;
  final HiveBoxes hiveBoxes;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.networkInfo,
    required this.profileLocalDataSource,
    required this.hiveBoxes,
  });

  @override
  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        var response = await profileRemoteDataSource.logout();
        await profileLocalDataSource.logout();
        await hiveBoxes.clearHiveBoxes();
        await AuthenticationWithGoogle.signOut();
        return Right(response);
      } on AuthenticationException {
        await hiveBoxes.clearHiveBoxes();
        await profileLocalDataSource.logout();
        return Left(
          AuthenticationFailure(errorMessage: 'Token invalid or expired'),
        );
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  // user profile feature

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(
      {required bool isRefreshed, String? userId}) async {
    try {
      if (!await networkInfo.isConnected) {
        final userProfile = await profileLocalDataSource.getCachedUserProfile();
        if (userProfile != null) {
          return Right(userProfile);
        }
        return Left(NetworkFailure());
      }
      final response =
          await profileRemoteDataSource.getUserProfile(userId: userId);

      return Right(response);
    } on AuthenticationException {
      await profileLocalDataSource.logout();
      await hiveBoxes.clearHiveBoxes();
      return Left(
        AuthenticationFailure(errorMessage: 'Token invalid or expired'),
      );
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChangePasswordEntity>> postChangePassword(
      String oldPassword, String newPassword, String repeatPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await profileRemoteDataSource.postChangePassword(
            oldPassword, newPassword, repeatPassword);

        return Right(response);
      } on AuthenticationException {
        await profileLocalDataSource.logout();

        return Left(
          AuthenticationFailure(errorMessage: 'Token invalid or expired'),
        );
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  // username feature
  @override
  Future<Either<Failure, ChangeUsernameEntity>> postChangeUsername(
      String firstname, String lastname) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await profileRemoteDataSource.postChangeUsername(
            firstname, lastname);

        UserCredential localUser =
            await profileLocalDataSource.getUserCredential();

        UserCredentialModel updatedUserCredential = UserCredentialModel(
            id: response.id,
            email: response.email,
            firstName: response.firstName,
            lastName: response.lastName,
            token: localUser.token,
            department: response.department,
            departmentId: response.departmentId);
        await profileLocalDataSource.updateUserCredntial(
            updatedUserCredntialInformation: updatedUserCredential);

        return const Right(ChangeUsernameEntity());
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
      ProfileUpdateEntity updateEntity) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await profileRemoteDataSource.updateProfile(updateEntity);

        UserCredential localUser =
            await profileLocalDataSource.getUserCredential();

        UserCredentialModel updatedUserCredential = UserCredentialModel(
          id: response.id,
          email: response.email,
          firstName: response.firstName,
          lastName: response.lastName,
          profileAvatar: response.profileAvatar,
          token: localUser.token,
          department: response.department,
          departmentId: response.departmentId,
          school: response.school,
          grade: response.grade,
          examType: response.examType,
        );
        await profileLocalDataSource.updateUserCredntial(
            updatedUserCredntialInformation: updatedUserCredential);

        return const Right(Void);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Leaderboard>> getTopUsers(
      {required int page, required LeaderboardType leaderboardtype}) async {
    if (await networkInfo.isConnected) {
      try {
        final topUsers = await profileRemoteDataSource.getTopUsers(
            page: page, leaderboardType: leaderboardtype);
        return Right(topUsers);
      } on AuthenticationException {
        await profileLocalDataSource.logout();
        await hiveBoxes.clearHiveBoxes();
        return Left(
          AuthenticationFailure(errorMessage: 'Token invalid or expired'),
        );
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ConsistencyEntity>>> getUserConsistencyData(
      {required String year, String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final consistencyData = await profileRemoteDataSource
            .getConsistencyData(year: year, userId: userId);
        return Right(consistencyData);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SchoolDepartmentInfo>> getSchoolInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final consistencyData = await profileRemoteDataSource.getSchoolInfo();
        return Right(consistencyData);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ScoreCategoryListEntity>> getBarChartData() async {
    if (await networkInfo.isConnected) {
      try {
        final barchartData = await profileRemoteDataSource.getBarChartData();
        return Right(barchartData);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
