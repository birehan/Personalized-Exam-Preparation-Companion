import 'dart:ffi';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/user_leaderboard_entity.dart';
import '../../../features.dart';
import '../../../../core/core.dart';

class ProfileRepositoryImpl implements ProfileRepositories {
  final NetworkInfo networkInfo;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profileLocalDataSource;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.networkInfo,
    required this.profileLocalDataSource,
  });

  @override
  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        var response = await profileRemoteDataSource.logout();
        await profileLocalDataSource.logout();
        return Right(response);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  // user profile feature

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await profileRemoteDataSource.getUserProfile();
        return Right(response);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  //password feature
  @override
  Future<Either<Failure, ChangePasswordEntity>> postChangePassword(
      String oldPassword, String newPassword, String repeatPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await profileRemoteDataSource.postChangePassword(
            oldPassword, newPassword, repeatPassword);

        return Right(response);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
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
        return Left(mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUserAvatar(File imagePath) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await profileRemoteDataSource.updateUserAvatar(imagePath);

        UserCredential localUser =
            await profileLocalDataSource.getUserCredential();

        UserCredentialModel updatedUserCredential = UserCredentialModel(
            email: response.email,
            firstName: response.firstName,
            lastName: response.lastName,
            profileAvatar: response.profileAvatar,
            token: localUser.token,
            department: response.department,
            departmentId: response.departmentId);
        await profileLocalDataSource.updateUserCredntial(
            updatedUserCredntialInformation: updatedUserCredential);

        return const Right(Void);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserLeaderboardEntity>>> getTopUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final topUsers = await profileRemoteDataSource.getTopUsers();
        return Right(topUsers);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
