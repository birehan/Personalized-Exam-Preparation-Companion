import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/all_barchart_categories_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';

class GetBarChartDataUseCase
    extends UseCase<ScoreCategoryListEntity, NoParams> {
  final ProfileRepositories profileRepositories;

  GetBarChartDataUseCase({required this.profileRepositories});

  @override
  Future<Either<Failure, ScoreCategoryListEntity>> call(NoParams params) {
    return profileRepositories.getBarChartData();
  }
}
