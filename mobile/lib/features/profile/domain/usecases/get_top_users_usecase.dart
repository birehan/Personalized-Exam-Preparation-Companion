import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/user_leaderboard_entity.dart';

class GetTopUsersUsecase
    extends UseCase<List<UserLeaderboardEntity>, NoParams> {
  final ProfileRepositories profileRepositories;

  GetTopUsersUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, List<UserLeaderboardEntity>>> call(params) async {
    return await profileRepositories.getTopUsers();
  }
}
