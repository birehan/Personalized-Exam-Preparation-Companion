import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/question/domain/entities/general_chat_entity.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  final QuestionLocalDatasource localDatasource;
  final QuestionRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  QuestionRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> submitUserAnswer(
      List<QuestionUserAnswer> questionUserAnswers) async {
    if (await networkInfo.isConnected) {
      await remoteDatasource.submitUserAnswer(
        questionUserAnswers,
      );
      return const Right(unit);
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<EndQuestionsAndAnswer>>>
      getEndofSubtopicQuestions(String subtopicId) async {
    if (await networkInfo.isConnected) {
      try {
        final questions =
            await remoteDatasource.getEndofSubtopicQuestions(subtopicId);
        return Right(questions);
      } on ServerException {
        Left(ServerFailure());
      }
    }

    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChatResponse>> chat(
    String questionId,
    String userQuestion,
    List<ChatHistory> chatHistory,
    bool isContest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final chatResponse = await remoteDatasource.chat(
            questionId, userQuestion, chatHistory, isContest);
        return Right(chatResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<EndQuestionsAndAnswer>>> getEndOfChapterQuestions(
      String chapterId) async {
    if (await networkInfo.isConnected) {
      try {
        final questions =
            await remoteDatasource.getEndofChapterQuestions(chapterId);
        return Right(questions);
      } on ServerException {
        Left(ServerFailure());
      }
    }

    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChatResponse>> sendGeneralChat(
      {required GeneralChatEntity chat}) async {
    try {
      final chatResponse =
          await remoteDatasource.sendGeneralChat(generalChat: chat);
      return Right(chatResponse);
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Question>> getQuestionById(
      {required String questionId}) async {
    try {
      final question =
          await remoteDatasource.getQuestionById(questionId: questionId);
      return Right(question);
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }
}
