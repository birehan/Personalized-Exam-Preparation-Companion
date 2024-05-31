import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class MarkCourseAsDownloadedUsecase
    extends UseCase<Unit, MarkCourseAsDownloadedParams> {
  final CourseRepositories courseRepositories;

  MarkCourseAsDownloadedUsecase({
    required this.courseRepositories,
  });

  @override
  Future<Either<Failure, Unit>> call(MarkCourseAsDownloadedParams params) async {
    return await courseRepositories.markCourseAsDownloaded(params.courseId);
  }
}

class MarkCourseAsDownloadedParams extends Equatable {
  final String courseId;

  const MarkCourseAsDownloadedParams({
    required this.courseId,
  });

  @override
  List<Object?> get props => [courseId];
}
