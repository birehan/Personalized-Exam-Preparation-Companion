import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../authentication/domain/entities/user_credential.dart';
import '../../domain/entities/onboarding_questions_response.dart';
import '../../domain/usecases/submit_onboarding_questions.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingAnswersState> {
  final SubmitOnbardingQuestionsUsecase submitOnbardingQuestionsUsecase;
  OnboardingBloc({required this.submitOnbardingQuestionsUsecase})
      : super(
          const OnboardingAnswersState(
              subjectsToCover: [],
              validResponse: false,
              reponseSubmissionFailed: false,
              responseSubmitted: false,
              responseSubmitting: false),
        ) {
    on<PreparationLevelChangedEvent>(_onPreparationLevelChange);
    on<PreparationMethodChangedEvent>(_onPreparationMethodChanged);
    on<DedicationTimeChangedEvent>(_onDedicationTimeChange);
    on<UserMotiveChangedEvent>(_onUserMotiveChange);
    on<StreamChangedEvent>(_onStreamChange);
    on<ReminderTimeChangedEvent>(_onReminderTimeChange);
    on<SubjectsChangedEvent>(_onSubjectsChange);
    on<OnboardingQuestionsResponseSubmittedEvent>(_onSubmitted);
    on<OnContinueButtonPressedEvent>(_onContinue);
    on<GenderChangedEvent>(_onGenderChanged);
    on<SchoolChangedEvent>(_onSchoolChanged);
    on<RegionChnagedEvent>(_onRegionChanged);
  }
  void _onGenderChanged(
      GenderChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onSchoolChanged(
      SchoolChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(highSchool: event.school));
  }

  void _onRegionChanged(
      RegionChnagedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(region: event.region));
  }

  void _onPreparationLevelChange(PreparationLevelChangedEvent event,
      Emitter<OnboardingAnswersState> emit) {
    emit(
      state.copyWith(preparationLevel: event.preparationLevel),
    );
  }

  void _onPreparationMethodChanged(PreparationMethodChangedEvent event,
      Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(preparationMethod: event.preparationMethod));
  }

  void _onDedicationTimeChange(
      DedicationTimeChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(dedicationTime: event.dedicationTime));
  }

  void _onUserMotiveChange(
      UserMotiveChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(userMotive: event.userMotive));
  }

  void _onStreamChange(
      StreamChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(
      stream: event.stream,
    ));
  }

  void _onSubjectsChange(
      SubjectsChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    final subjectIndex = event.subjectIndex;
    List<int> selectedSubjects = List.from(state.subjectsToCover);

    if (selectedSubjects.contains(subjectIndex)) {
      selectedSubjects.remove(subjectIndex);
    } else {
      selectedSubjects.add(event.subjectIndex);
    }

    emit(state.copyWith(subjectsToCover: selectedSubjects));
  }

  void _onReminderTimeChange(
      ReminderTimeChangedEvent event, Emitter<OnboardingAnswersState> emit) {
    emit(state.copyWith(reminderTime: event.reminderTime));
  }

  void _onSubmitted(OnboardingQuestionsResponseSubmittedEvent event,
      Emitter<OnboardingAnswersState> emit) async {
    emit(state.copyWith(responseSubmitting: true));
    // this implementation is temporary
    List<String> chalangingSub = [];

    if (state.stream == 0) {
      for (int i = 0; i < state.subjectsToCover.length; i++) {
        chalangingSub.add(naturalSubjects[state.subjectsToCover[i]].title);
      }
    } else {
      for (int i = 0; i < state.subjectsToCover.length; i++) {
        chalangingSub.add(socialSubjects[state.subjectsToCover[i]].title);
      }
    }
    OnboardingQuestionsResponse userResponse = OnboardingQuestionsResponse(
      howPrepared: howPrepared[state.preparationLevel!],
      preferedMethod: preferedMethod[state.preparationMethod!],
      studyTimePerday: studyTimePerday[state.dedicationTime!],
      motivation: motivation[state.userMotive!],
      // id: streamId[state.stream!],
      // challengingSubjects: chalangingSub,
      reminderTime: state.reminderTime,
      // gender: state.gender!,
      // region: state.region!,
      // school: state.highSchool!,
    );

    // Either<Failure, UserCredential> response =
    //     await submitOnbardingQuestionsUsecase(
    //   OnboardingQuestionsParams(onboardingQuestionsResponse: userResponse),
    // );

    // Simulate a successful submission
    // await Future.delayed(Duration(seconds: 1)); // Simulating an API call

    // emit(state.copyWith(
    //   responseSubmitting: false,
    //   responseSubmitted: true,
    // ));

    // emit(_eitherFailureOrVoid(response));

    emit(state.copyWith(
      responseSubmitting: false,
      responseSubmitted: true,
    ));
  }

  // Reminder: remove the next implementation of _onSubmitted() function and replace with the above commented implementation once the backend works:
  // void _onSubmitted(OnboardingQuestionsResponseSubmittedEvent event,
  //     Emitter<OnboardingAnswersState> emit) async {
  //   emit(state.copyWith(responseSubmitting: true));

  //   // Simulate a successful submission
  //   await Future.delayed(Duration(seconds: 1)); // Simulating an API call

  //   emit(state.copyWith(
  //     responseSubmitting: false,
  //     responseSubmitted: true,
  //   ));

  //   print(state.responseSubmitted); /* true! */
  //   print(state.reponseSubmissionFailed);
  //   print(state.validResponse); /* true! */
  //   print(state.responseSubmitting);
  // }

  // I have not used the userCredential
  OnboardingAnswersState _eitherFailureOrVoid(
      Either<Failure, UserCredential> response) {
    print(response.toString());
    return response.fold(
      (l) => state.copyWith(
          reponseSubmissionFailed: true, responseSubmitting: false),
      (r) => state.copyWith(responseSubmitted: true, responseSubmitting: false),
    );
  }

  void _onContinue(OnContinueButtonPressedEvent event,
      Emitter<OnboardingAnswersState> emit) {
    emit(
      state.copyWith(validResponse: checkFormValidity()),
    );
  }

  bool checkFormValidity() {
    bool isValid = state.dedicationTime != null &&
        state.preparationLevel != null &&
        state.preparationMethod != null &&
        state.userMotive != null;
    // state.stream != null;
    // state.gender != null;
    // state.highSchool != null &&
    // state.region != null;
    return isValid;
  }
}
