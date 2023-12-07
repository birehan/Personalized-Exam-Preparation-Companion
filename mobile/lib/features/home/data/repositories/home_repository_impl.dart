import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeLocalDatasource localDatasource;
  final HomeRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ExamDate>>> getExamDate() async {
    if (await networkInfo.isConnected) {
      try {
        final examDate = await remoteDatasource.getExamDate();
        // await localDatasource.cacheExamDate(examDate);
        return Right(examDate);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
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
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
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
  Future<Either<Failure, HomeEntity>> getHomeContent() async {
    if (await networkInfo.isConnected) {
      try {
        final homeEntity = await remoteDatasource.getHomeContent();
        return Right(homeEntity);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }
}
