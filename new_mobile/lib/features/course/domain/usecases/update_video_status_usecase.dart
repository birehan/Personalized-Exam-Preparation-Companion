import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class UpdateVideoStatusUsecase extends UseCase<bool, UpdateVideoStatusParams> {
  final CourseRepositories repository;

  UpdateVideoStatusUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(UpdateVideoStatusParams params) async {
    return await repository.updateVideoStatus(
        videoId: params.videoId, isCompleted: params.isCompleted);
  }
}

class UpdateVideoStatusParams {
  final String videoId;
  final bool isCompleted;

  UpdateVideoStatusParams({required this.videoId, required this.isCompleted});
}
