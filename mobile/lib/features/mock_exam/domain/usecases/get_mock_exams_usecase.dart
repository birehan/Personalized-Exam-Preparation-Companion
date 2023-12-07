import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetMockExamsUsecase extends UseCase<List<MockExam>, NoParams> {
  final MockExamRepository repository;

  GetMockExamsUsecase(this.repository);

  @override
  Future<Either<Failure, List<MockExam>>> call(NoParams params) async {
    return await repository.getMocks();
  }
}
