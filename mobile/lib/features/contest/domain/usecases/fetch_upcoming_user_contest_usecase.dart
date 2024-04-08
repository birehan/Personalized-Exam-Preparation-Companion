import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchUpcomingUserContestUsecase extends UseCase<Contest?, NoParams> {
  FetchUpcomingUserContestUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, Contest?>> call(NoParams params) async {
    return await repository.fetchUpcomingUserContest();
  }
}
