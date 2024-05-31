import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class GetDepartmentCourseUsecase
    extends UseCase<DepartmentCourse, DepartmentIdParams> {
  final CourseRepositories repository;

  GetDepartmentCourseUsecase({required this.repository});

  @override
  Future<Either<Failure, DepartmentCourse>> call(
      DepartmentIdParams params) async {
    return await repository.getDepartmentCourse(params.id);
  }
}
