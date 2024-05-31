part of 'alert_dialog_bloc.dart';

class AlertDialogState extends Equatable {
  const AlertDialogState();

  @override
  List<Object?> get props => [];
}

class AlertDialogInitial extends AlertDialogState {}

enum AlertDialogStatus { loading, loaded, error }

class LearningQuizModeState extends AlertDialogState {
  const LearningQuizModeState({
    required this.status,
    this.examId,
    this.questionNumber,
    this.questionMode,
    this.retake,
    this.downloadedUserMock,
  });

  final AlertDialogStatus status;
  final String? examId;
  final int? questionNumber;
  final QuestionMode? questionMode;
  final bool? retake;
  final DownloadedUserMock? downloadedUserMock;

  @override
  List<Object?> get props =>
      [status, examId, questionMode, retake, downloadedUserMock];
}
