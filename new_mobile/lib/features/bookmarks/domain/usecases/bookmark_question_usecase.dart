import 'package:dartz/dartz.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/bookmarks/domain/repositories/repositories.dart';

class QuestionBookmarkUsecase extends UseCase<void, QuestionBookmarkParams> {
  final BookmarkRepositories bookmarkRepositories;

  QuestionBookmarkUsecase({required this.bookmarkRepositories});
  @override
  Future<Either<Failure, void>> call(QuestionBookmarkParams params) async {
    return await bookmarkRepositories.bookmarkQuestion(params.questionId);
  }
}

class QuestionBookmarkParams {
  final String questionId;

  QuestionBookmarkParams({required this.questionId});
}
