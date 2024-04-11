import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_info_enitity.dart';

class GetSchoolInfoUsecase extends UseCase<SchoolDepartmentInfo, NoParams> {
  final ProfileRepositories profileRepositories;

  GetSchoolInfoUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, SchoolDepartmentInfo>> call(NoParams params) async {
    return await profileRepositories.getSchoolInfo();
  }
}
