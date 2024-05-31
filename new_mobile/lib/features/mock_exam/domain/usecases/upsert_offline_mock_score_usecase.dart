import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class UpsertOfflineMockScoreUsecase
    extends UseCase<void, UpsertOfflineMockScoreParams> {
  UpsertOfflineMockScoreUsecase({
    required this.repository,
  });

  final MockExamRepository repository;

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.upsertOfflineMockScore(
      params.mockId,
      params.score,
      params.isCompleted,
    );
  }
}

class UpsertOfflineMockScoreParams extends Equatable {
  final String mockId;
  final int score;
  final bool isCompleted;

  const UpsertOfflineMockScoreParams({
    required this.mockId,
    required this.score,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        mockId,
        score,
        isCompleted,
      ];
}
