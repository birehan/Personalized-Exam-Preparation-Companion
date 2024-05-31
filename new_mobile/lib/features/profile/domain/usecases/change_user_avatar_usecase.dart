import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/profile_update_entity.dart';

class UpdateUserProfileUsecase extends UseCase<void, ProfileUpdateParams> {
  final ProfileRepositories profileRepositories;

  UpdateUserProfileUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, void>> call(ProfileUpdateParams params) async {
    return profileRepositories.updateProfile(params.updateEntity);
  }
}

class ProfileUpdateParams {
  final ProfileUpdateEntity updateEntity;

  ProfileUpdateParams({required this.updateEntity});
}
