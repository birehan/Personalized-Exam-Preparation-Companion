import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetAllGeneralDepartmentUsecase
    extends UseCase<List<GeneralDepartment>, NoParams> {
  final DepartmentRepository repository;

  GetAllGeneralDepartmentUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<GeneralDepartment>>> call(NoParams params) async {
    return await repository.getAllDepartments();
  }
}
