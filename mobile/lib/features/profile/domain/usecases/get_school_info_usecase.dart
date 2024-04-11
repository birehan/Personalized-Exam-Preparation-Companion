import 'package:dartz/dartz.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/profile/domain/entities/school_info_enitity.dart';

class GetSchoolInfoUsecase extends UseCase<SchoolDepartmentInfo, NoParams> {
  final ProfileRepositories profileRepositories;

  GetSchoolInfoUsecase({required this.profileRepositories});
  @override
  Future<Either<Failure, SchoolDepartmentInfo>> call(NoParams params) async {
    return await profileRepositories.getSchoolInfo();
  }
}
