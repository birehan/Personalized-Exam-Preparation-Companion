import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class IsCourseDownloadedUsecase
    extends UseCase<bool, IsCourseDownloadedParams> {
  final CourseRepositories courseRepositories;

  IsCourseDownloadedUsecase({
    required this.courseRepositories,
  });

  @override
  Future<Either<Failure, bool>> call(IsCourseDownloadedParams params) async {
    return await courseRepositories.isCourseDownloaded(params.courseId);
  }
}

class IsCourseDownloadedParams extends Equatable {
  final String courseId;

  const IsCourseDownloadedParams({
    required this.courseId,
  });

  @override
  List<Object?> get props => [courseId];
}
