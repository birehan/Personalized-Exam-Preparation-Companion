import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';

class GetHomeUsecase extends UseCase<HomeEntity, GetHomeParams> {
  final HomeRepository repository;

  GetHomeUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, HomeEntity>> call(GetHomeParams params) async {
    return await repository.getHomeContent(params.refresh);
  }
}

class GetHomeParams {
  final bool refresh;

  GetHomeParams({required this.refresh});
}
