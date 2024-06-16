import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/profile/domain/entities/all_barchart_categories_entity.dart';
import 'package:prep_genie/features/profile/domain/entities/consistency_entity.dart';

class GetBarChartDataUseCase
    extends UseCase<ScoreCategoryListEntity, NoParams> {
  final ProfileRepositories profileRepositories;

  GetBarChartDataUseCase({required this.profileRepositories});

  @override
  Future<Either<Failure, ScoreCategoryListEntity>> call(NoParams params) {
    return profileRepositories.getBarChartData();
  }
}
