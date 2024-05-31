part of 'popup_menu_bloc.dart';

abstract class PopupMenuState extends Equatable {
  const PopupMenuState();

  @override
  List<Object> get props => [];
}

class PopupMenuInitial extends PopupMenuState {}

enum PopupMenuStatus { loading, loaded, error }

class TimesUpState extends PopupMenuState {
  final PopupMenuStatus status;

  const TimesUpState({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}

class QuitExamState extends PopupMenuState {
  final PopupMenuStatus status;

  const QuitExamState({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}

