import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/bookmarks/domain/repositories/repositories.dart';

class ContentBookmarkUsecase extends UseCase<bool, ContentBookmarkParams> {
  final BookmarkRepositories bookmarkRepositories;

  ContentBookmarkUsecase({required this.bookmarkRepositories});
  @override
  Future<Either<Failure, bool>> call(ContentBookmarkParams params) async {
    return await bookmarkRepositories.bookmarkContent(params.contnetId);
  }
}

class ContentBookmarkParams {
  final String contnetId;

  ContentBookmarkParams({required this.contnetId});
}
