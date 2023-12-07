import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class MockExamRepository {
  Future<Either<Failure, List<MockExam>>> getMocks();
  Future<Either<Failure, Mock>> getMockById(String id);
  Future<Either<Failure, MockExam>> getMockAnalysis();
  Future<Either<Failure, List<DepartmentMock>>> getDepartmentMocks(
    String departmentId,
    bool isStandard,
  );
  Future<Either<Failure, Unit>> upsertMockScore(String mockId, int score);
  Future<Either<Failure, List<UserMock>>> getMyMocks();
  Future<Either<Failure, Unit>> addMocktoUserMocks(String mockId);
}
