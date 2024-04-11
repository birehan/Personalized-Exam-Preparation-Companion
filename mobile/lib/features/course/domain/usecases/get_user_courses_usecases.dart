import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../domain.dart';

class UserCoursesUseCase extends UseCase<List<UserCourse>, UserCoursesParams> {
  final CourseRepositories courseRepositories;

  UserCoursesUseCase({required this.courseRepositories});

  @override
  Future<Either<Failure, List<UserCourse>>> call(
      UserCoursesParams params) async {
    return await courseRepositories.getUserCourses(params.refresh);
  }
}

class UserCoursesParams {
  final bool refresh;

  UserCoursesParams({required this.refresh});
}
