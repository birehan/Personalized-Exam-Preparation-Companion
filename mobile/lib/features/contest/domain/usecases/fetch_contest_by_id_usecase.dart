import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchContestByIdUsecase extends UseCase<Contest, FetchContestByIdParams> {
  FetchContestByIdUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, Contest>> call(FetchContestByIdParams params) async {
    return await repository.fetchContestById(contestId: params.contestId);
  }
}

class FetchContestByIdParams extends Equatable {
  const FetchContestByIdParams({
    required this.contestId,
  });

  final String contestId;

  @override
  List<Object?> get props => [];
}
