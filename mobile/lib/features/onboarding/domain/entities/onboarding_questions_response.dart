import 'package:equatable/equatable.dart';

class OnboardingQuestionsResponse extends Equatable {
  final String howPrepared;
  final String preferedMethod;
  final String studyTimePerday;
  final String motivation;
  final String id;
  final List<String> challengingSubjects;
  final DateTime? reminderTime;

  const OnboardingQuestionsResponse({
    required this.howPrepared,
    required this.preferedMethod,
    required this.studyTimePerday,
    required this.motivation,
    required this.id,
    required this.challengingSubjects,
    this.reminderTime,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        howPrepared,
        preferedMethod,
        studyTimePerday,
        motivation,
        id,
        challengingSubjects
      ];
}
