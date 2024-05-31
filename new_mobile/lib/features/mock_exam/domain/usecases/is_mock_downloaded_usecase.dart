import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class IsMockDownloadedUsecase extends UseCase<bool, IsMockDownloadedParams> {
  final MockExamRepository repository;

  IsMockDownloadedUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, bool>> call(IsMockDownloadedParams params) async {
    return await repository.isMockDownloaded(params.mockId);
  }
}

class IsMockDownloadedParams extends Equatable {
  final String mockId;

  const IsMockDownloadedParams({
    required this.mockId,
  });

  @override
  List<Object?> get props => [mockId];
}
