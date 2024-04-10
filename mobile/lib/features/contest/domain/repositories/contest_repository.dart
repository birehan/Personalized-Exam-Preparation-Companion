import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class ContestRepository {
  Future<Either<Failure, List<Contest>>> fetchPreviousContests();
  Future<Either<Failure, Contest>> fetchContestById({
    required String contestId,
  });
  Future<Either<Failure, List<Contest>>> fetchPreviousUserContests();
  Future<Either<Failure, ContestModel?>> fetchUpcomingUserContest();
  Future<Either<Failure, Contest>> registerUserToContest(String contestId);
  Future<Either<Failure, ContestDetail>> getContestDetail(String contestId);
  Future<Either<Failure, ContestRank>> getContestRanking(String contestId);
  Future<Either<Failure, List<ContestQuestion>>>
      fetchContestQuestionsByCategory({
    required String categoryId,
  });
  Future<Either<Failure, void>> submitUserContestAnswer(
    ContestUserAnswer contestUserAnswer,
  );
  Future<Either<Failure, List<ContestQuestion>>>
      fetchContestAnalysisByCategory({
    required String categoryId,
  });
}
