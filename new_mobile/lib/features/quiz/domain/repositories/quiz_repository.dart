import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<Quiz>>> getQuizByCourseId({
    required String courseId,
    required bool isRefreshed,
  });
  Future<Either<Failure, String>> createQuiz({
    required String name,
    required List<String> chapters,
    required int numberOfQuestion,
    required String courseId,
  });
  Future<Either<Failure, QuizQuestion>> getQuizById({
    required String quizId,
    required bool isRefreshed,
  });
  Future<Either<Failure, Unit>> saveQuizScore({
    required String quizId,
    required int score,
  });
}
