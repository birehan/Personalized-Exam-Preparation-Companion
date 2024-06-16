part of 'change_video_status_bloc.dart';

class ChangeVideoStatusEvent extends Equatable {
  const ChangeVideoStatusEvent();

  @override
  List<Object> get props => [];
}

class ChangeSingleVideoStatusEvent extends ChangeVideoStatusEvent {
  final String videoId;
  final bool isCompleted;

  const ChangeSingleVideoStatusEvent(
      {required this.videoId, required this.isCompleted});
}
