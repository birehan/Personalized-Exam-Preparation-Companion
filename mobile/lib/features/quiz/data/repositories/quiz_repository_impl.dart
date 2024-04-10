import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class QuizRepositoryImpl extends QuizRepository {
  final QuizRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final QuizLocalDatasource localDatasource;

  QuizRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, List<Quiz>>> getQuizByCourseId({
    required String courseId,
    required bool isRefreshed,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final quizzes = await remoteDataSource.getQuizByCourseId(courseId);
        return Right(quizzes);
      } else {
        final cachedQuiz = await localDatasource.getQuiz(courseId);
        if (cachedQuiz != null) {
          return Right(cachedQuiz);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> createQuiz({
    required String name,
    required List<String> chapters,
    required int numberOfQuestion,
    required String courseId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final quizId = await remoteDataSource.createQuiz(
          name: name,
          chapters: chapters,
          numberOfQuestion: numberOfQuestion,
          courseId: courseId,
        );
        return Right(quizId);
      } on CreateQuizException catch (e) {
        return Left(CreateQuizFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, QuizQuestion>> getQuizById({
    required String quizId,
    required bool isRefreshed,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final quizQuestion = await remoteDataSource.getQuizById(quizId);
        return Right(quizQuestion);
      } else {
        final cachedQuizQuestions =
            await localDatasource.getQuizQuestions(quizId);
        if (cachedQuizQuestions != null) {
          return Right(cachedQuizQuestions);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveQuizScore({
    required String quizId,
    required int score,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.saveQuizScore(quizId: quizId, score: score);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }
}
