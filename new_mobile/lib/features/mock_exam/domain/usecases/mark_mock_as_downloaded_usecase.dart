import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class MarkMockAsDownloadedUsecase
    extends UseCase<Unit, MarkMockAsDownloadedParams> {
  final MockExamRepository repository;

  MarkMockAsDownloadedUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(MarkMockAsDownloadedParams params) async {
    return await repository.markMockAsDownloaded(params.mockId);
  }
}

class MarkMockAsDownloadedParams extends Equatable {
  final String mockId;

  const MarkMockAsDownloadedParams({
    required this.mockId,
  });

  @override
  List<Object?> get props => [mockId];
}
