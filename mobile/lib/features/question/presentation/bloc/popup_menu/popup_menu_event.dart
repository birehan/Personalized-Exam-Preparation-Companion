part of 'popup_menu_bloc.dart';

abstract class PopupMenuEvent extends Equatable {
  const PopupMenuEvent();

  @override
  List<Object> get props => [];
}

class TimesUpEvent extends PopupMenuEvent {}

class QuitExamEvent extends PopupMenuEvent {}
