import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchContestAnalysisByCategoryUsecase extends UseCase<
    List<ContestQuestion>, FetchContestAnalysisByCategoryParams> {
  FetchContestAnalysisByCategoryUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, List<ContestQuestion>>> call(
      FetchContestAnalysisByCategoryParams params) async {
    return await repository.fetchContestAnalysisByCategory(
      categoryId: params.categoryId,
    );
  }
}

class FetchContestAnalysisByCategoryParams extends Equatable {
  const FetchContestAnalysisByCategoryParams({
    required this.categoryId,
  });

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}
