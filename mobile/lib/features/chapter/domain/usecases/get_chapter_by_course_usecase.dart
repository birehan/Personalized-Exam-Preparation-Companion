import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetChapterByCourseIdUsecase
    extends UseCase<List<Chapter>, GetChapterByCourseIdParams> {
  final ChapterRepository repository;

  GetChapterByCourseIdUsecase(this.repository);

  @override
  Future<Either<Failure, List<Chapter>>> call(params) async {
    return await repository.getChaptersByCourseId(params.courseId);
  }
}

class GetChapterByCourseIdParams extends Equatable {
  final String courseId;

  const GetChapterByCourseIdParams({
    required this.courseId,
  });

  @override
  List<Object?> get props => [courseId];
}
