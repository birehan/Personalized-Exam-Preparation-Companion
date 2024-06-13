import '../../domain/entities/onboarding_questions_response.dart';

class OnboardingQuestionsModel extends OnboardingQuestionsResponse {
  const OnboardingQuestionsModel({
    required super.howPrepared,
    required super.preferedMethod,
    required super.studyTimePerday,
    required super.motivation,
    required super.id,
    required super.challengingSubjects,
    required super.reminderTime,
    required super.gender,
    required super.school,
    required super.region,
  });

  Map<String, dynamic> toJson() {
    return {
      'howPrepared': howPrepared,
      'preferredMetho': preferedMethod,
      'studyTimePerDa': studyTimePerday,
      'motivation': motivation,
      'department': id,
      'challengingSubjects': challengingSubjects,
      'reminder': reminderTime.toString(),
      'highSchool': school,
      'region': region,
      'gender': gender,
    };
  }
}
