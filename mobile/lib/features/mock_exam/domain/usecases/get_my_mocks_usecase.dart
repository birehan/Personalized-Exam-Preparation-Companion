import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetMyMocksUsecase extends UseCase<List<UserMock>, NoParams> {
  final MockExamRepository repository;

  GetMyMocksUsecase(this.repository);

  @override
  Future<Either<Failure, List<UserMock>>> call(NoParams params) async {
    return await repository.getMyMocks();
  }
}
