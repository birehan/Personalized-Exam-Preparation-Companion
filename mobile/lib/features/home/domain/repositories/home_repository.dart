import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<UserCourse>>> getMyCourses();
  Future<Either<Failure, List<ExamDate>>> getExamDate();
  Future<Either<Failure, HomeEntity>> getHomeContent();
}
