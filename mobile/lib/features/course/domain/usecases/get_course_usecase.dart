import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../domain.dart';

class GetCourseWithAnalysisUsecase
    extends UseCase<UserCourseAnalysis, CourseIdParams> {
  final CourseRepositories courseRepository;

  GetCourseWithAnalysisUsecase(
    this.courseRepository,
  );

  @override
  Future<Either<Failure, UserCourseAnalysis>> call(
      CourseIdParams params) async {
    return await courseRepository.getCourseById(
      id: params.id,
      isRefreshed: params.isRefreshed,
    );
  }
}

class CourseIdParams extends Equatable {
  final String id;
  final bool isRefreshed;

  const CourseIdParams({
    required this.id,
    required this.isRefreshed,
  });

  @override
  List<Object?> get props => [id, isRefreshed];
}
