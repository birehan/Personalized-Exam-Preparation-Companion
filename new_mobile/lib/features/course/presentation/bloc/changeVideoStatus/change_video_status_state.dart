part of 'change_video_status_bloc.dart';

class ChangeVideoStatusState extends Equatable {
  const ChangeVideoStatusState();

  @override
  List<Object> get props => [];
}

class ChangeVideoStatusInitial extends ChangeVideoStatusState {}

class VideoStatusChangedState extends ChangeVideoStatusState {}

class ChangeVideoStatusLoading extends ChangeVideoStatusState {}

class ChangeVideoStatusFailed extends ChangeVideoStatusState {}
