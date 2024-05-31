import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_bridge_mobile/core/constants/app_keys.dart';
import 'package:skill_bridge_mobile/core/utils/hive_boxes.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeLocalDatasource localDatasource;
  final HomeRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage flutterSecureStorage;

  HomeRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
    required this.flutterSecureStorage,
  });

  @override
  Future<Either<Failure, List<ExamDate>>> getExamDate() async {
    if (await networkInfo.isConnected) {
      try {
        final examDate = await remoteDatasource.getExamDate();
        // await localDatasource.cacheExamDate(examDate);
        return Right(examDate);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      // try {
      //   final examDate = await localDatasource.getExamDate();
      //   return Right(examDate);
      // } on CacheException {
      //   return Left(CacheFailure());
      // }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserCourse>>> getMyCourses() async {
    if (await networkInfo.isConnected) {
      try {
        final myCourses = await remoteDatasource.getMyCourses();
        // await localDatasource.cacheMyCourses(myCourses);
        return Right(myCourses);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      // try {
      //   final myCourses = await localDatasource.getMyCourses();
      //   return Right(myCourses);
      // } on CacheException {
      //   return Left(CacheFailure());
      // }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> getHomeContent(bool refresh) async {
    try {
      if (await networkInfo.isConnected) {
        final homeContent = await remoteDatasource.getHomeContent();
        return Right(homeContent);
      } else {
        final homeContent = await localDatasource.getCachedHomeState();
        if (homeContent != null) {
          return Right(homeContent);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DailyStreak>> fetchDailyStreak(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final dailyStreak =
            await remoteDatasource.fetchDailyStreak(startDate, endDate);
        return Right(dailyStreak);
      } else {
        final dailyStreak =
            await localDatasource.getCachedDailyStreak(startDate, endDate);
        if (dailyStreak != null) {
          return Right(dailyStreak);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DailyQuiz>> fetchDailyQuiz() async {
    try {
      if (await networkInfo.isConnected) {
        final dailyQuiz = await remoteDatasource.fetchDailyQuiz();
        return Right(dailyQuiz);
      } else {
        final dailyQuiz = await localDatasource.getCachedDailyQuiz();
        if (dailyQuiz != null) {
          return Right(dailyQuiz);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DailyQuiz>> fetchDailyQuizForAnalysis(
      String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final dailyQuiz = await remoteDatasource.fetchDailyQuizForAnalysis(id);
      return Right(dailyQuiz);
    // } on AuthenticationException {
    //   await flutterSecureStorage.delete(key: authenticationKey);
    //   return Left(
    //     AuthenticationFailure(errorMessage: 'Token invalid or expired'),
    //   );
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitDailyQuizAnswer(
      DailyQuizAnswer dailyQuizAnswer) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      await remoteDatasource.submitDailyQuizAnswer(dailyQuizAnswer);
      return const Right(unit);
    } catch(e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DailyQuest>>> fetchDailyQuest() async {
    try {
      if (await networkInfo.isConnected) {
        final dailyQuest = await remoteDatasource.fetchDailyQuest();
        return Right(dailyQuest);
      } else {
        final dailyQuest = await localDatasource.getCachedDailyQuest();
        if (dailyQuest != null) {
          return Right(dailyQuest);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }
}
