part of 'alert_dialog_bloc.dart';

class AlertDialogEvent extends Equatable {
  const AlertDialogEvent();

  @override
  List<Object?> get props => [];
}

class LearningQuizModeEvent extends AlertDialogEvent {
  const LearningQuizModeEvent({
    required this.examId,
    required this.questionMode,
    this.questionNumber,
    this.retake,
    this.downloadedUserMock,
  });

  final String examId;
  final QuestionMode questionMode;
  final int? questionNumber;
  final bool? retake;
  final DownloadedUserMock? downloadedUserMock;

  @override
  List<Object?> get props => [examId, questionMode, questionNumber, retake, downloadedUserMock];
}
