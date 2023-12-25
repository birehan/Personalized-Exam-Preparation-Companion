import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/change_password_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/change_username_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/user_profile_entity_get.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_leaderboard_entity.dart';

abstract class ProfileRepositories {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, ChangeUsernameEntity>> postChangeUsername(
      String firstname, String lastname);
  Future<Either<Failure, ChangePasswordEntity>> postChangePassword(
      String oldPassword, String newPassword, String repeatPassword);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, void>> updateUserAvatar(File imagePath);
  Future<Either<Failure, List<UserLeaderboardEntity>>> getTopUsers();
}
