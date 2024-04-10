import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/entities/entities.dart';

import '../../../../core/error/failure.dart';

abstract class BookmarkRepositories {
  Future<Either<Failure, Bookmarks>> getUserBookmarks();
  Future<Either<Failure, bool>> bookmarkContent(String contentId);
  Future<Either<Failure, void>> removeBookmarkedContent(String contentId);
  Future<Either<Failure, void>> bookmarkQuestion(String qeustionId);
  Future<Either<Failure, void>> removeQuestionBookmark(String questionId);
}
