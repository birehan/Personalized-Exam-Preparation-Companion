import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class UpsertMockScoreUsecase extends UseCase<void, UpsertMockScoreParams> {
  final MockExamRepository repository;

  UpsertMockScoreUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.upsertMockScore(
      params.mockId,
      params.score,
    );
  }
}

class UpsertMockScoreParams extends Equatable {
  final String mockId;
  final int score;

  const UpsertMockScoreParams({
    required this.mockId,
    required this.score,
  });

  @override
  List<Object?> get props => [
        mockId,
        score,
      ];
}
