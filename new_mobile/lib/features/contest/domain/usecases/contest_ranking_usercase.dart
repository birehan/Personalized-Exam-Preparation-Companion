import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';

class GetContestRankingUsecase
    extends UseCase<ContestRank, ContestRankingParams> {
  final ContestRepository contestRepository;

  GetContestRankingUsecase({required this.contestRepository});
  @override
  Future<Either<Failure, ContestRank>> call(ContestRankingParams params) async {
    return await contestRepository.getContestRanking(params.contestId);
  }
}

class ContestRankingParams {
  final String contestId;

  ContestRankingParams({required this.contestId});
}
