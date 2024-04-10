import 'package:equatable/equatable.dart';

class OnboardingQuestionsResponse extends Equatable {
  final String howPrepared;
  final String preferedMethod;
  final String studyTimePerday;
  final String motivation;
  final String? id;
  final List<String>? challengingSubjects;
  final DateTime? reminderTime;
  final String? region;
  final String? school;
  final String? gender;

  const OnboardingQuestionsResponse({
    this.gender,
    this.school,
    this.region,
    required this.howPrepared,
    required this.preferedMethod,
    required this.studyTimePerday,
    required this.motivation,
    this.id,
    this.challengingSubjects,
    this.reminderTime,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        howPrepared,
        preferedMethod,
        studyTimePerday,
        motivation,
        // id,
      ];
}
