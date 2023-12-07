import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetExamDateUsecase extends UseCase<List<ExamDate>, NoParams> {
  final HomeRepository repository;

  GetExamDateUsecase(this.repository);

  @override
  Future<Either<Failure, List<ExamDate>>> call(NoParams params) async {
    return await repository.getExamDate();
  }
}
