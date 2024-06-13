import 'package:dartz/dartz.dart';
import 'package:prep_genie/features/contest/domain/entities/contest_detail.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ContestRepositoryImpl extends ContestRepository {
  ContestRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  final ContestLocalDatasource localDatasource;
  final ContestRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Contest>>> fetchPreviousContests() async {
    try {
      if (await networkInfo.isConnected) {
        final contests = await remoteDatasource.fetchPreviousContests();
        return Right(contests);
      } else {
        final contests = await localDatasource.getPreviousContests();

        if (contests != null) {
          return Right(contests);
        } else {
          return Left(NetworkFailure());
        }
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Contest>> fetchContestById(
      {required String contestId}) async {
    if (await networkInfo.isConnected) {
      try {
        final contest =
            await remoteDatasource.fetchContestById(contestId: contestId);
        return Right(contest);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<Contest>>> fetchPreviousUserContests() async {
    try {
      if (await networkInfo.isConnected) {
        final contests = await remoteDatasource.fetchPreviousUserContests();
        return Right(contests);
      } else {
        final contests = await localDatasource.getPreviousUserContests();

        if (contests != null) {
          return Right(contests);
        } else {
          return Left(NetworkFailure());
        }
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ContestModel?>> fetchUpcomingUserContest() async {
    if (await networkInfo.isConnected) {
      try {
        final contest = await remoteDatasource.fetchUpcomingUserContest();
        return Right(contest);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Contest>> registerUserToContest(
      String contestId) async {
    if (await networkInfo.isConnected) {
      try {
        final contest = await remoteDatasource.registerToContest(contestId);
        return Right(contest);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ContestDetail>> getContestDetail(
      String contestId) async {
    try {
      if (await networkInfo.isConnected) {
        final contestDetail =
            await remoteDatasource.getContestDetail(contestId);
        return Right(contestDetail);
      } else {
        final contestDetail = await localDatasource.getContestDetail(contestId);

        if (contestDetail != null) {
          return Right(contestDetail);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ContestRank>> getContestRanking(
      String contestId) async {
    if (await networkInfo.isConnected) {
      try {
        final contestDetail =
            await remoteDatasource.getContestRanking(contestId);
        return Right(contestDetail);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ContestQuestion>>>
      fetchContestQuestionsByCategory({
    required String categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final contestQuestions =
            await remoteDatasource.fetchContestQuestionByCategory(
          categoryId: categoryId,
        );
        return Right(contestQuestions);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> submitUserContestAnswer(
      ContestUserAnswer contestUserAnswer) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.submitUserContestAnswer(contestUserAnswer);
        return const Right(unit);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ContestQuestion>>> fetchContestAnalysisByCategory(
      {required String categoryId}) async {
    if (await networkInfo.isConnected) {
      try {
        final contestQuestions =
            await remoteDatasource.fetchContestAnalysisByCategory(
          categoryId: categoryId,
        );
        return Right(contestQuestions);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }
}
