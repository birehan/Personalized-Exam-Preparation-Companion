import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class FetchPreviousUserContestsUsecase
    extends UseCase<List<Contest>, NoParams> {
  FetchPreviousUserContestsUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, List<Contest>>> call(NoParams params) async {
    return await repository.fetchPreviousUserContests();
  }
}
