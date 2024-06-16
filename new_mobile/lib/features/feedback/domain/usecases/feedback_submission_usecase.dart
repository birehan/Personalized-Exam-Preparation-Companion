import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

import '../entities/feedback_entity.dart';
import '../repositories/feedback_repositories.dart';

class SubmitContentFeedbackUsecase extends UseCase<void, FeedbackParams> {
  final FeedbackRepositories feedbackRepositories;

  SubmitContentFeedbackUsecase({required this.feedbackRepositories});
  @override
  Future<Either<Failure, void>> call(FeedbackParams params) {
    return feedbackRepositories.submitFeedback(params.feedback);
  }
}

class FeedbackParams {
  final FeedbackEntity feedback;

  FeedbackParams({required this.feedback});
}
