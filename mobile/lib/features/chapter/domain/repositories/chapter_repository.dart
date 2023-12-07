import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../entities/sub_chapters_entity.dart';

abstract class ChapterRepository {
  Future<Either<Failure, List<Chapter>>> allChapters(String courseId);
  Future<Either<Failure, SubChapters>> loadSubChapters(String chapterId);
  Future<Either<Failure, SubChapter>> loadContent(String subChapterId);
  Future<Either<Failure, List<Chapter>>> getChaptersByCourseId(String courseId);
}
