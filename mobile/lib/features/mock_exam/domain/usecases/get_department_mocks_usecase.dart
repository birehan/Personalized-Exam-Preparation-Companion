import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetDepartmentMocksUsecase
    extends UseCase<List<DepartmentMock>, DepartmentMocksParams> {
  final MockExamRepository repository;

  GetDepartmentMocksUsecase(this.repository);

  @override
  Future<Either<Failure, List<DepartmentMock>>> call(params) async {
    return await repository.getDepartmentMocks(
        params.departmentId, params.isStandard);
  }
}

class DepartmentMocksParams extends Equatable {
  final String departmentId;
  final bool isStandard;

  const DepartmentMocksParams({
    required this.departmentId,
    required this.isStandard,
  });

  @override
  List<Object?> get props => [departmentId, isStandard];
}
