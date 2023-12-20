import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/profile/domain/repositories/profile_repository.dart.dart';

import '../../../../core/core.dart';
import '../entities/user_profile_entity_get.dart';

class GetProfileUsecase extends UseCase<UserProfile, NoParams> {
  final ProfileRepositories profileRepositories;

  GetProfileUsecase({required this.profileRepositories});

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await profileRepositories.getUserProfile();
  }
}

