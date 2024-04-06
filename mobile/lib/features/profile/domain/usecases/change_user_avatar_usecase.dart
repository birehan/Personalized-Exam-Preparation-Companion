import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

class ChangeUserAvatarUsecase extends UseCase<void, AvatarChangeParams> {
  final ProfileRepositories profileRepositories;

  ChangeUserAvatarUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, void>> call(AvatarChangeParams params) async {
    return profileRepositories.updateUserAvatar(params.imagePath);
  }
}

class AvatarChangeParams {
  final File imagePath;

  AvatarChangeParams({required this.imagePath});
}
