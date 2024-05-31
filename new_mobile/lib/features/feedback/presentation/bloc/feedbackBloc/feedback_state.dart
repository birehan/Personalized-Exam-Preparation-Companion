part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FlagingInitial extends FeedbackState {}

class FeedbackSubmitedState extends FeedbackState {}

class FeedbackSubmisionFailedState extends FeedbackState {
  final String errorMessage;
  final Failure failure;

  const FeedbackSubmisionFailedState({required this.errorMessage, required this.failure});
}

class FeedbackSubmissionInProgress extends FeedbackState {}
