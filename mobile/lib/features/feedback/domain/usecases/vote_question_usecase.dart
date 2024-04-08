import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/feedback_repositories.dart';

class VoteQuestionUsecase extends UseCase<void, VoteQuestionParams> {
  final FeedbackRepositories feedbackRepositories;

  VoteQuestionUsecase({required this.feedbackRepositories});
  @override
  Future<Either<Failure, void>> call(VoteQuestionParams params) {
    return feedbackRepositories.voteQuestion(params.questionId, params.isLiked);
  }
}

class VoteQuestionParams {
  final String questionId;
  final bool isLiked;
  VoteQuestionParams({required this.isLiked, required this.questionId});
}
