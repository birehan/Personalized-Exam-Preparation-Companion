import 'package:dartz/dartz.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/profile/domain/entities/consistency_entity.dart';

class GetUserConsistencyDataUsecase
    extends UseCase<List<ConsistencyEntity>, ConsistencyParams> {
  final ProfileRepositories profileRepositories;

  GetUserConsistencyDataUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, List<ConsistencyEntity>>> call(
      ConsistencyParams params) {
    return profileRepositories.getUserConsistencyData(
        year: params.year, userId: params.userId);
  }
}

class ConsistencyParams {
  final String year;
  final String? userId;
  ConsistencyParams({required this.year, this.userId});
}
