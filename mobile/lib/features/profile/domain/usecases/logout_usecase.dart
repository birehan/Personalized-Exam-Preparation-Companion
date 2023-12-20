import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/profile_repository.dart.dart';

class ProfileLogoutUsecase extends UseCase<bool, NoParams> {
  final ProfileRepositories profileRepositories;

  ProfileLogoutUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await profileRepositories.logout();
  }
}
