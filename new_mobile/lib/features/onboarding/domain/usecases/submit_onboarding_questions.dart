// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../authentication/domain/entities/user_credential.dart';
import '../entities/onboarding_questions_response.dart';
import '../repositories/onboarding_questions_repositories.dart';

class SubmitOnbardingQuestionsUsecase
    extends UseCase<UserCredential, OnboardingQuestionsParams> {
  OnboardingQuestionsRepository onboardingQuestionsRepository;
  SubmitOnbardingQuestionsUsecase({
    required this.onboardingQuestionsRepository,
  });
  @override
  Future<Either<Failure, UserCredential>> call(
      OnboardingQuestionsParams params) async {
    return await onboardingQuestionsRepository
        .submitOnboardingResponse(params.onboardingQuestionsResponse);
  }
}

class OnboardingQuestionsParams {
  final OnboardingQuestionsResponse onboardingQuestionsResponse;

  OnboardingQuestionsParams({required this.onboardingQuestionsResponse});
}
