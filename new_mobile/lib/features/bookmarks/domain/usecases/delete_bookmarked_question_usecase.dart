import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/bookmarks/domain/domain.dart';

class DeleteQuestionBookmarkUsecase
    extends UseCase<void, DeleteQuestionBookmarkParams> {
  final BookmarkRepositories bookmarkRepositories;

  DeleteQuestionBookmarkUsecase({required this.bookmarkRepositories});
  @override
  Future<Either<Failure, void>> call(
      DeleteQuestionBookmarkParams params) async {
    return await bookmarkRepositories.removeQuestionBookmark(params.questionId);
  }
}

class DeleteQuestionBookmarkParams {
  final String questionId;

  DeleteQuestionBookmarkParams({required this.questionId});
}
