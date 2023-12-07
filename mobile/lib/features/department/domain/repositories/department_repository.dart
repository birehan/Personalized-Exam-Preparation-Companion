import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class DepartmentRepository {
  Future<Either<Failure, List<GeneralDepartment>>> getAllDepartments();
}
