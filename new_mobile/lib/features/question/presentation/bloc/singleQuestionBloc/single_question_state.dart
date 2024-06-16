part of 'single_question_bloc.dart';

class SingleQuestionState extends Equatable {
  const SingleQuestionState();

  @override
  List<Object> get props => [];
}

class SingleQuestionInitial extends SingleQuestionState {}

class SingleQuestionLoadedState extends SingleQuestionState {
  final Question question;

  const SingleQuestionLoadedState({required this.question});
}

class SingleQuestionLoadingState extends SingleQuestionState {}

class SingleQuestionFailedState extends SingleQuestionState {
  final Failure failure;

  const SingleQuestionFailedState({required this.failure});
}
