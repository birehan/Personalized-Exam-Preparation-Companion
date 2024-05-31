import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class FetchDownloadedMocksUsecase extends UseCase<List<DownloadedUserMock>, NoParams> {
  final MockExamRepository repository;

  FetchDownloadedMocksUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<DownloadedUserMock>>> call(NoParams params) async {
    return await repository.fetchDownloadedMocks();
  }
}
