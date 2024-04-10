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
  Future<Either<Failure, Mock>> getMockById(String id, int pageNumber) async {
    try {
      if (await networkInfo.isConnected) {
        final mockExam = await remoteDatasource.getMockById(id, pageNumber);
        return Right(mockExam);
      } else {
        final cachedMock = await localDatasource.getCachedMockExam(
          id: id,
          pageNumer: pageNumber,
        );

        if (cachedMock != null) {
          return Right(cachedMock);
        } else {
          return Left(NetworkFailure());
        }
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MockExam>>> getMocks({
    required bool isRefreshed,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final mockExams = await remoteDatasource.getMocks();
        return Right(mockExams);
      } else {
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DepartmentMock>>> getDepartmentMocks({
    required String departmentId,
    required bool isStandard,
    required bool isRefreshed,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final mockExams = await remoteDatasource.getDepartmentMocks(
          departmentId,
          isStandard,
        );
        return Right(mockExams);
      } else {
        final mockExams = await localDatasource.getDepartmentMocks(
          id: departmentId,
          isStandard: isStandard,
        );

        if (mockExams != null) {
          return Right(mockExams);
        } else {
          return Left(NetworkFailure());
        }
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> upsertMockScore(
      String mockId, int score) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.upsertMockScore(mockId, score);
        return const Right(unit);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<UserMock>>> getMyMocks({
    required bool isRefreshed,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final mocks = await remoteDatasource.getMyMocks();
        return Right(mocks);
      } else {
        final cachedUserMock = await localDatasource.getMyMocks();
        if (cachedUserMock != null) {
          return Right(cachedUserMock);
        } else {
          return Left(NetworkFailure());
        }
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
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

  @override
  Future<Either<Failure, Unit>> retakeMock(String mockId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.retakeMock(mockId);
        return const Right(unit);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }
}
