import 'package:dartz/dartz.dart';

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
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final chatResponse =
            await remoteDatasource.chat(questionId, userQuestion, chatHistory);
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
}
