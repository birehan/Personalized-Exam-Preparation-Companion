import 'package:dartz/dartz.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/contest/domain/entities/contest_detail.dart';
import 'package:prepgenie/features/features.dart';

class GetContestDetailUsecase
    extends UseCase<ContestDetail, ContestDetailParams> {
  final ContestRepository contestRepository;

  GetContestDetailUsecase({required this.contestRepository});
  @override
  Future<Either<Failure, ContestDetail>> call(
      ContestDetailParams params) async {
    return await contestRepository.getContestDetail(params.contestId);
  }
}

class ContestDetailParams {
  final String contestId;
  ContestDetailParams({required this.contestId});
}
