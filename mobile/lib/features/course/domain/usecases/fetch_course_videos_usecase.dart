import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class FetchCourseVideosUsecase
    extends UseCase<List<ChapterVideo>, FetchCourseVideoParams> {
  final CourseRepositories courseRepositories;

  FetchCourseVideosUsecase({
    required this.courseRepositories,
  });

  @override
  Future<Either<Failure, List<ChapterVideo>>> call(
      FetchCourseVideoParams params) async {
    return await courseRepositories.fetchCourseVideos(params.courseId);
  }
}

class FetchCourseVideoParams extends Equatable {
  final String courseId;

  const FetchCourseVideoParams({
    required this.courseId,
  });

  @override
  List<Object?> get props => [courseId];
}
