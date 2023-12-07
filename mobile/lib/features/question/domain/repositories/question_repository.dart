import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class QuestionRepository {
  Future<Either<Failure, Unit>> submitUserAnswer(
    List<QuestionUserAnswer> questionUserAnswers,
  );
  Future<Either<Failure, List<EndQuestionsAndAnswer>>>
      getEndofSubtopicQuestions(String subtopicId);
  Future<Either<Failure, List<EndQuestionsAndAnswer>>> getEndOfChapterQuestions(
      String chapterId);
  Future<Either<Failure, ChatResponse>> chat(
    String questionId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  );
}
