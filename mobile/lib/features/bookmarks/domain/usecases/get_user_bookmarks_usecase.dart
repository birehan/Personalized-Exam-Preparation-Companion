import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/repositories/repositories.dart';

import '../entities/bookmarked_contents_and_questions.dart';

class GetUserBookmarksUsecase extends UseCase<Bookmarks, NoParams> {
  final BookmarkRepositories bookmarkRepositories;

  GetUserBookmarksUsecase({required this.bookmarkRepositories});
  @override
  Future<Either<Failure, Bookmarks>> call(NoParams params) async {
    return await bookmarkRepositories.getUserBookmarks();
  }
}
