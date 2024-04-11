import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/feedback_entity.dart';

abstract class FeedbackRepositories {
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback);
  Future<Either<Failure, void>> voteQuestion(String questionId, bool isLiked);
}
