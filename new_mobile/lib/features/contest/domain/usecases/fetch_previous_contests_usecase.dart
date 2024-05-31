import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchPreviousContestsUsecase extends UseCase<List<Contest>, NoParams> {
  FetchPreviousContestsUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, List<Contest>>> call(NoParams params) async {
    return await repository.fetchPreviousContests();
  }
}
