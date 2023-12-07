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
  });
  // factory OnboardingQuestionsModel.fromJson(Map<String, dynamic> json) {
  //   return OnboardingQuestionsModel(
  //     id: json['_id'],
  //     userId: json['userId'],
  //     course: CourseModel.fromUserCourseJson(json['course']),
  //     completedChapters: json['completedChapters'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'howPrepared': howPrepared,
      'preferredMetho': preferedMethod,
      'studyTimePerDa': studyTimePerday,
      'motivation': motivation,
      'department': id,
      'challengingSubjects': challengingSubjects,
      'reminder': reminderTime.toString(),
    };
  }
}
