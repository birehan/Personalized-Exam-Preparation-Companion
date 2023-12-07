import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../domain.dart';

class UserCoursesUseCase extends UseCase<List<UserCourse>, NoParams> {
  final CourseRepositories courseRepositories;

  UserCoursesUseCase({required this.courseRepositories});

  @override
  Future<Either<Failure, List<UserCourse>>> call(NoParams params) async {
    return await courseRepositories.getUserCourses();
  }
}
