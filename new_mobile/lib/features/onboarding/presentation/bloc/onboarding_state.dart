part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingAnswersState extends OnboardingState {
  final int? preparationLevel;
  final int? preparationMethod;
  final int? dedicationTime;
  final int? userMotive;
  final int? stream;
  final String? highSchool;
  final String? region;
  final String? gender;
  final List<int> subjectsToCover;
  final DateTime? reminderTime;
  final bool validResponse;
  final bool responseSubmitted;
  final bool reponseSubmissionFailed;
  final bool responseSubmitting;
  const OnboardingAnswersState({
    required this.responseSubmitted,
    required this.reponseSubmissionFailed,
    required this.responseSubmitting,
    required this.validResponse,
    this.preparationLevel,
    this.reminderTime,
    this.preparationMethod,
    this.dedicationTime,
    this.userMotive,
    this.stream,
    required this.subjectsToCover,
    this.gender,
    this.highSchool,
    this.region,
  });

  OnboardingAnswersState copyWith(
      {DateTime? reminderTime,
      int? preparationLevel,
      int? preparationMethod,
      int? dedicationTime,
      int? userMotive,
      int? stream,
      List<int>? subjectsToCover,
      bool? validResponse,
      bool? reponseSubmissionFailed,
      bool? responseSubmitting,
      String? gender,
      String? highSchool,
      String? region,
      bool? responseSubmitted}) {
    return OnboardingAnswersState(
      dedicationTime: dedicationTime ?? this.dedicationTime,
      userMotive: userMotive ?? this.userMotive,
      preparationLevel: preparationLevel ?? this.preparationLevel,
      preparationMethod: preparationMethod ?? this.preparationMethod,
      stream: stream ?? this.stream,
      subjectsToCover: subjectsToCover ?? this.subjectsToCover,
      reminderTime: reminderTime ?? this.reminderTime,
      validResponse: validResponse ?? this.validResponse,
      reponseSubmissionFailed:
          reponseSubmissionFailed ?? this.reponseSubmissionFailed,
      responseSubmitted: responseSubmitted ?? this.responseSubmitted,
      responseSubmitting: responseSubmitting ?? this.responseSubmitting,
      gender: gender ?? this.gender,
      highSchool: highSchool ?? this.highSchool,
      region: region ?? this.region,
    );
  }

  @override
  List<Object?> get props => [
        preparationLevel,
        preparationMethod,
        dedicationTime,
        userMotive,
        stream,
        subjectsToCover,
        reminderTime,
        validResponse,
        reponseSubmissionFailed,
        responseSubmitted,
        responseSubmitting,
        highSchool,
        gender,
        region,
      ];
}

class OnboardingQuestionsSubmittedState extends OnboardingState {}

class OnboardingQuestionsLoadingState extends OnboardingState {}

class OnboardingQuestionsSubmissionFailedState extends OnboardingState {
  final String errorMessage;
  final Failure failure;

  const OnboardingQuestionsSubmissionFailedState({
    required this.errorMessage,
    required this.failure,
  });
}
