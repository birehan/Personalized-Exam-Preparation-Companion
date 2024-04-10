import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class DepartmentRepositoryImpl extends DepartmentRepository {
  final DepartmentRemoteDatasource remoteDatasource;
  final DepartmentLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  DepartmentRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GeneralDepartment>>> getAllDepartments() async {
    if (await networkInfo.isConnected) {
      try {
        final generalDepartments = await remoteDatasource.getAllDepartments();
        return Right(generalDepartments);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      print('--------------- network not available -----------');
      return Left(NetworkFailure());
    }
  }
}
