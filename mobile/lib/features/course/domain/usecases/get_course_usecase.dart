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
    return await courseRepository.getCourseById(params.id);
  }
}



class CourseIdParams extends Equatable {
  final String id;

  const CourseIdParams({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
