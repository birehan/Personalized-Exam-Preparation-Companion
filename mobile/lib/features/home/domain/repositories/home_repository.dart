import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<UserCourse>>> getMyCourses();
  Future<Either<Failure, List<ExamDate>>> getExamDate();
  Future<Either<Failure, HomeEntity>> getHomeContent(bool refresh);
  Future<Either<Failure, DailyStreak>> fetchDailyStreak(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, DailyQuiz>> fetchDailyQuiz();
  Future<Either<Failure, DailyQuiz>> fetchDailyQuizForAnalysis(String id);
  Future<Either<Failure, Unit>> submitDailyQuizAnswer(
      DailyQuizAnswer dailyQuizAnswer);
  Future<Either<Failure, List<DailyQuest>>> fetchDailyQuest();
}
