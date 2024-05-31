import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/question/domain/entities/general_chat_entity.dart';

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
    bool isContest,
  );
  Future<Either<Failure, ChatResponse>> sendGeneralChat(
      {required GeneralChatEntity chat});
  Future<Either<Failure, Question>> getQuestionById(
      {required String questionId});
}
