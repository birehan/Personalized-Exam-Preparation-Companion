import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class FetchDownloadedCoursesUsecase extends UseCase<List<Course>, NoParams> {
  final CourseRepositories courseRepositories;

  FetchDownloadedCoursesUsecase({
    required this.courseRepositories,
  });

  @override
  Future<Either<Failure, List<Course>>> call(NoParams params) async {
    return await courseRepositories.fetchDownloadedCourses();
  }
}
