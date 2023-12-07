import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class QuizRepositoryImpl extends QuizRepository {
  final QuizRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  QuizRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Quiz>>> getQuizByCourseId(String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        final quizzes = await remoteDataSource.getQuizByCourseId(courseId);
        return Right(quizzes);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
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
  Future<Either<Failure, QuizQuestion>> getQuizById(String quizId) async {
    if (await networkInfo.isConnected) {
      try {
        final quizQuestion = await remoteDataSource.getQuizById(quizId);
        return Right(quizQuestion);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
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
