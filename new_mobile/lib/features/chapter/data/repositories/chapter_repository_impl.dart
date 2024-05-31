import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

import '../../domain/entities/sub_chapters_entity.dart';

import '../../../features.dart';
import '../datasources/chapter_remote_data_source.dart';

class ChapterRepositoryImpl extends ChapterRepository {
  final NetworkInfo networkInfo;
  final ChapterRemoteDatasource chapterRemoteDatasource;

  ChapterRepositoryImpl({
    required this.networkInfo,
    required this.chapterRemoteDatasource,
  });
  @override
  Future<Either<Failure, List<Chapter>>> allChapters(String courseId) {
    // TODO: implement allChapters
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SubChapter>> loadContent(String subChapterId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await chapterRemoteDatasource.loadContent(subChapterId));
      } on ServerException {
        return Left(
            ServerFailure(errorMessage: 'Content is currently unavailable'));
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, SubChapters>> loadSubChapters(
      String subChapterId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(
            await chapterRemoteDatasource.loadSubChapters(subChapterId));
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<Chapter>>> getChaptersByCourseId(
      String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        final chapters =
            await chapterRemoteDatasource.getChaptersByCourseId(courseId);
        return Right(chapters);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }
}
