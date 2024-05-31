import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class DownloadMockByIdUsecase
    extends UseCase<Unit, DownloadMockByIdParams> {
  final MockExamRepository repository;

  DownloadMockByIdUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(DownloadMockByIdParams params) async {
    return await repository.downloadMockById(params.mockId);
  }
}

class DownloadMockByIdParams extends Equatable {
  final String mockId;

  const DownloadMockByIdParams({
    required this.mockId,
  });

  @override
  List<Object?> get props => [mockId];
}
