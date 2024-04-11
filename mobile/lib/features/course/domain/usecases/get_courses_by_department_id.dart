import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../repositories/repositories.dart';
import '../entities/entities.dart';

class GetCoursesByDepartmentIdUseCase
    extends UseCase<List<Course>, DepartmentIdParams> {
  final CourseRepositories courseRepositories;

  GetCoursesByDepartmentIdUseCase({required this.courseRepositories});

  @override
    Future<Either<Failure, List<Course>>> call(DepartmentIdParams params) async {
    return await courseRepositories.getCoursesByDepartmentId(params.id);
  }
}

class DepartmentIdParams {
  final String id;

  DepartmentIdParams({required this.id});
}
