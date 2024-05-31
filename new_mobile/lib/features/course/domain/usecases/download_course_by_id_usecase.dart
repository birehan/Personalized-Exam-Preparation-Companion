import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class DownloadCourseByIdUsecase
    extends UseCase<Unit, DownloadCourseByIdParams> {
  final CourseRepositories courseRepositories;

  DownloadCourseByIdUsecase({
    required this.courseRepositories,
  });

  @override
  Future<Either<Failure, Unit>> call(DownloadCourseByIdParams params) async {
    return await courseRepositories.downloadCourseById(params.courseId);
  }
}

class DownloadCourseByIdParams extends Equatable {
  final String courseId;

  const DownloadCourseByIdParams({
    required this.courseId,
  });

  @override
  List<Object?> get props => [courseId];
}
