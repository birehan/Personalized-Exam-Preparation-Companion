 part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FlagingInitial extends FeedbackState {}

class FeedbackSubmitedState extends FeedbackState {}

class FeedbackSubmisionFailedState extends FeedbackState {
  final String message;

  const FeedbackSubmisionFailedState({required this.message});
}

class FeedbackSubmissionInProgress extends FeedbackState {}
