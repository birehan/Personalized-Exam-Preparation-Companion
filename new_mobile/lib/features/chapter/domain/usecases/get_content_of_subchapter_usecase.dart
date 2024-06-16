import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/sub_chapter.dart';
import '../repositories/chapter_repository.dart';

class GetContentOfSubChapterUsecase
    extends UseCase<SubChapter, GetContentParams> {
  final ChapterRepository chapterRepository;

  GetContentOfSubChapterUsecase({required this.chapterRepository});
  @override
  Future<Either<Failure, SubChapter>> call(GetContentParams params) async {
    return await chapterRepository.loadContent(params.id);
  }
}

class GetContentParams {
  final String id;
  GetContentParams({required this.id});
}
