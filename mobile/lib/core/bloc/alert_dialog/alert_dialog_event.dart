part of 'alert_dialog_bloc.dart';

class AlertDialogEvent extends Equatable {
  const AlertDialogEvent();

  @override
  List<Object> get props => [];
}

class LearningQuizModeEvent extends AlertDialogEvent {
  const LearningQuizModeEvent({
    required this.examId,
    required this.questionMode,
  });

  final String examId;
  final QuestionMode questionMode;

  @override
  List<Object> get props => [examId, questionMode];
}
