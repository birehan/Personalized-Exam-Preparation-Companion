import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class RegisterSubChapterUsecase
    extends UseCase<bool, SubChapterRegistrationParams> {
  final CourseRepositories courseRepositories;

  RegisterSubChapterUsecase({required this.courseRepositories});
  @override
  Future<Either<Failure, bool>> call(
      SubChapterRegistrationParams params) async {
    return await courseRepositories.registerSubChapter(
        params.subChapterid, params.chapterId);
  }
}

class SubChapterRegistrationParams {
  final String subChapterid;
  final String chapterId;

  SubChapterRegistrationParams(
      {required this.chapterId, required this.subChapterid});
}
