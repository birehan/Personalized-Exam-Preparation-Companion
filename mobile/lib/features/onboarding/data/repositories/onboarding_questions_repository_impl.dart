import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../features.dart';
import '../../domain/entities/onboarding_questions_response.dart';
import '../../domain/repositories/onboarding_questions_repositories.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/network/network.dart';
import '../datasources/onboarding_pages_remote_datasource.dart';

class OnboardingQuestionsRepositoryImpl
    implements OnboardingQuestionsRepository {
  final AuthenticationLocalDatasource authLocalDatasource;
  final OnboardingQuestionsRemoteDataSource remoteDatasource;
  final NetworkInfo networkInfo;

  OnboardingQuestionsRepositoryImpl({
    required this.authLocalDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, UserCredential>> submitOnboardingResponse(
      OnboardingQuestionsResponse onboardingQuestionsResponse) async {
    if (await networkInfo.isConnected) {
      try {
        UserCredentialModel userCredential = await remoteDatasource
            .submitOnboardingQuestions(onboardingQuestionsResponse);

        print(userCredential);

        //call the update
        await authLocalDatasource.updateUserCredntial(
            updatedUserCredntialInformation: userCredential);
        //return
        return Right(userCredential);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      } on UnauthorizedRequestException {
        return Left(UnauthorizedRequestFailure());
      } catch (e) {
        return Left(AnonymousFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
