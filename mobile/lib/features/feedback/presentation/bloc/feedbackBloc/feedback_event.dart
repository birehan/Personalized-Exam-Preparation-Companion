part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class FeedbackSubmittedEvent extends FeedbackEvent {
  final FeedbackEntity feedback;

  const FeedbackSubmittedEvent({required this.feedback});
}
