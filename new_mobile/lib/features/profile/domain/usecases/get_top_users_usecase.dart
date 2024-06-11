import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';
import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'package:prep_genie/features/profile/presentation/widgets/leaderboard_tab.dart';

class GetTopUsersUsecase extends UseCase<Leaderboard, LeaderboardParams> {
  final ProfileRepositories profileRepositories;

  GetTopUsersUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, Leaderboard>> call(params) async {
    return await profileRepositories.getTopUsers(
        page: params.page, leaderboardtype: params.leaderboardType);
  }
}

class LeaderboardParams {
  final int page;
  final LeaderboardType leaderboardType;
  LeaderboardParams({required this.leaderboardType, required this.page});
}
