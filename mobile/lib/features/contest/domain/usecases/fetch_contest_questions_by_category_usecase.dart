import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchContestQuestionsByCategoryUsecase extends UseCase<
    List<ContestQuestion>, FetchContestQuestionsByCategoryParams> {
  FetchContestQuestionsByCategoryUsecase({
    required this.repository,
  });

  final ContestRepository repository;

  @override
  Future<Either<Failure, List<ContestQuestion>>> call(
      FetchContestQuestionsByCategoryParams params) async {
    return await repository.fetchContestQuestionsByCategory(
      categoryId: params.categoryId,
    );
  }
}

class FetchContestQuestionsByCategoryParams extends Equatable {
  const FetchContestQuestionsByCategoryParams({
    required this.categoryId,
  });

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}
