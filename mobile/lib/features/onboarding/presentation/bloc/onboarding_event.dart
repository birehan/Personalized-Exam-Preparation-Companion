part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class PreparationLevelChangedEvent extends OnboardingEvent {
  final int preparationLevel;

  const PreparationLevelChangedEvent({required this.preparationLevel});
  @override
  List<Object> get props => [preparationLevel];
}

class PreparationMethodChangedEvent extends OnboardingEvent {
  final int preparationMethod;

  const PreparationMethodChangedEvent({required this.preparationMethod});
  @override
  List<Object> get props => [preparationMethod];
}

class DedicationTimeChangedEvent extends OnboardingEvent {
  final int dedicationTime;

  const DedicationTimeChangedEvent({required this.dedicationTime});
  @override
  List<Object> get props => [dedicationTime];
}

class UserMotiveChangedEvent extends OnboardingEvent {
  final int userMotive;

  const UserMotiveChangedEvent({required this.userMotive});
  @override
  List<Object> get props => [userMotive];
}

class StreamChangedEvent extends OnboardingEvent {
  final int stream;

  const StreamChangedEvent({required this.stream});
  @override
  List<Object> get props => [stream];
}

class SubjectsChangedEvent extends OnboardingEvent {
  final int subjectIndex;

  const SubjectsChangedEvent({required this.subjectIndex});
  @override
  List<Object> get props => [subjectIndex];
}

class GenderChangedEvent extends OnboardingEvent {
  final String gender;

  const GenderChangedEvent({required this.gender});
  @override
  List<Object> get props => [gender];
}

class SchoolChangedEvent extends OnboardingEvent {
  final String school;

  const SchoolChangedEvent({required this.school});
  @override
  List<Object> get props => [school];
}

class RegionChnagedEvent extends OnboardingEvent {
  final String region;

  const RegionChnagedEvent({required this.region});
  @override
  List<Object> get props => [region];
}

class ReminderTimeChangedEvent extends OnboardingEvent {
  final DateTime reminderTime;

  const ReminderTimeChangedEvent({required this.reminderTime});
  @override
  List<Object> get props => [reminderTime];
}

class OnboardingQuestionsResponseSubmittedEvent extends OnboardingEvent {}

class OnContinueButtonPressedEvent extends OnboardingEvent {}

class OnResponseSubmittedEvent extends OnboardingEvent {}
