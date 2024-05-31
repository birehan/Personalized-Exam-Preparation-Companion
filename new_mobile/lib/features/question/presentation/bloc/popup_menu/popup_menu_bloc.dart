import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popup_menu_event.dart';
part 'popup_menu_state.dart';

class PopupMenuBloc extends Bloc<PopupMenuEvent, PopupMenuState> {
  PopupMenuBloc() : super(PopupMenuInitial()) {
    on<TimesUpEvent>(_onTimesUp);
    on<QuitExamEvent>(_onQuitExam);
  }

  void _onTimesUp(TimesUpEvent event, Emitter<PopupMenuState> emit) {
    emit(const TimesUpState(status: PopupMenuStatus.loading));
    emit(const TimesUpState(status: PopupMenuStatus.loaded));
  }

  void _onQuitExam(QuitExamEvent event, Emitter<PopupMenuState> emit) {
    emit(const QuitExamState(status: PopupMenuStatus.loading));
    emit(const QuitExamState(status: PopupMenuStatus.loaded));
  }
}
