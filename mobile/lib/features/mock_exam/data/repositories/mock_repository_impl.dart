import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MockExamRepositoryImpl extends MockExamRepository {
  final MockExamRemoteDatasource remoteDatasource;
  final MockExamLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  MockExamRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MockExam>> getMockAnalysis() async {
    if (await networkInfo.isConnected) {
      try {
        final mockAnalysis = await remoteDatasource.getMockAnalysis();
        return Right(mockAnalysis);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Mock>> getMockById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final mockExam = await remoteDatasource.getMockById(id);
        return Right(mockExam);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<MockExam>>> getMocks() async {
    if (await networkInfo.isConnected) {
      try {
        final mockExams = await remoteDatasource.getMocks();
        return Right(mockExams);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<DepartmentMock>>> getDepartmentMocks(
    String departmentId,
    bool isStandard,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final mockExams = await remoteDatasource.getDepartmentMocks(
          departmentId,
          isStandard,
        );
        return Right(mockExams);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> upsertMockScore(
      String mockId, int score) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.upsertMockScore(mockId, score);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<UserMock>>> getMyMocks() async {
    if (await networkInfo.isConnected) {
      try {
        final mocks = await remoteDatasource.getMyMocks();
        return Right(mocks);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> addMocktoUserMocks(String mockId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.addMocktoUserMocks(mockId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }
}
