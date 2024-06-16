import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/sub_chapters_entity.dart';
import '../repositories/chapter_repository.dart';

class GetSubChaptersListUsecase
    extends UseCase<SubChapters, SubChaptersListParams> {
  final ChapterRepository chapterRepository;

  GetSubChaptersListUsecase({required this.chapterRepository});
  @override
  Future<Either<Failure, SubChapters>> call(
      SubChaptersListParams params) async {
    return await chapterRepository.loadSubChapters(params.id);
  }
}

class SubChaptersListParams {
  final String id;

  SubChaptersListParams({required this.id});
}
