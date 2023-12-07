import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

class GetHomeUsecase extends UseCase<HomeEntity, NoParams> {
  final HomeRepository repository;

  GetHomeUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, HomeEntity>> call(NoParams params) async {
    return await repository.getHomeContent();
  }
}
