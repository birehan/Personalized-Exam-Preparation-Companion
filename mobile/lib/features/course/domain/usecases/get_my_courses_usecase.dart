import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class GetMyCoursesUsecase extends UseCase<List<UserCourse>, NoParams> {
  final HomeRepository repository;

  GetMyCoursesUsecase(this.repository);

  @override
  Future<Either<Failure, List<UserCourse>>> call(NoParams params) async {
    return await repository.getMyCourses();
  }
}
