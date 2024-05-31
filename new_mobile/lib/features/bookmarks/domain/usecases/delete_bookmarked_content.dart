import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';

class DeleteContentBookmarkUsecase
    extends UseCase<void, DeleteContentBookmarkParams> {
  final BookmarkRepositories bookmarkRepositories;

  DeleteContentBookmarkUsecase({required this.bookmarkRepositories});
  @override
  Future<Either<Failure, void>> call(DeleteContentBookmarkParams params) async {
    return await bookmarkRepositories.removeBookmarkedContent(params.contentId);
  }
}

class DeleteContentBookmarkParams {
  final String contentId;

  DeleteContentBookmarkParams({required this.contentId});
}
