import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class MockExamLocalDatasource {
  Future<Either<Failure, List<DepartmentMock>>> getMocks();
  Future<Either<Failure, void>> cacheMocks(List<DepartmentMock> mockExams);
}

class MockExamLocalDatasourceImpl extends MockExamLocalDatasource {
  @override
  Future<Either<Failure, List<DepartmentMock>>> getMocks() {
    // TODO: implement getMocks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> cacheMocks(List<DepartmentMock> mockExams) {
    // TODO: implement cacheMocks
    throw UnimplementedError();
  }
}
