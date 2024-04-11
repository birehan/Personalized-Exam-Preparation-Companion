import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ContestRegstrationUsecase
    extends UseCase<Contest, ContestRegistrationParams> {
  ContestRegstrationUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, Contest>> call(
      ContestRegistrationParams params) async {
    return await repository.registerUserToContest(params.contestId);
  }
}

class ContestRegistrationParams {
  final String contestId;
  ContestRegistrationParams({required this.contestId});
}
