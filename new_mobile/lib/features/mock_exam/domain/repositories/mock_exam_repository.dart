import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class MockExamRepository {
  Future<Either<Failure, List<MockExam>>> getMocks({
    required bool isRefreshed,
  });
  Future<Either<Failure, Mock>> getMockById(String id, int pageNumber);
  Future<Either<Failure, MockExam>> getMockAnalysis();
  Future<Either<Failure, List<DepartmentMock>>> getDepartmentMocks({
    required String departmentId,
    required bool isStandard,
    required bool isRefreshed,
  });
  Future<Either<Failure, Unit>> upsertMockScore(String mockId, int score);
  Future<Either<Failure, List<UserMock>>> getMyMocks({
    required bool isRefreshed,
  });
  Future<Either<Failure, Unit>> addMocktoUserMocks(String mockId);
  Future<Either<Failure, Unit>> retakeMock(String mockId);
  Future<Either<Failure, MockDetail>> getMockDetail(String mockId);
  Future<Either<Failure, Unit>> downloadMockById(String mockId);
  Future<Either<Failure, List<DownloadedUserMock>>> fetchDownloadedMocks();
  Future<Either<Failure, Unit>> markMockAsDownloaded(String mockId);
  Future<Either<Failure, bool>> isMockDownloaded(String mockId);
  Future<Either<Failure, Unit>> upsertOfflineMockUserAnswer(
      String mockId, List<QuestionUserAnswer> userAnswers);
  Future<Either<Failure, Unit>> upsertOfflineMockScore(
      String mockId, int score, bool isCompleted);
}
