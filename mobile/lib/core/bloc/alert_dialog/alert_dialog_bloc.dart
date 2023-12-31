import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core.dart';

part 'alert_dialog_event.dart';
part 'alert_dialog_state.dart';

class AlertDialogBloc extends Bloc<AlertDialogEvent, AlertDialogState> {
  AlertDialogBloc() : super(AlertDialogInitial()) {
    on<LearningQuizModeEvent>(_onLearningQuizMode);
  }

  void _onLearningQuizMode(
      LearningQuizModeEvent event, Emitter<AlertDialogState> emit) {
    emit(const LearningQuizModeState(status: AlertDialogStatus.loading));
    emit(
      LearningQuizModeState(
        status: AlertDialogStatus.loaded,
        examId: event.examId,
        questionMode: event.questionMode,
      ),
    );
  }
}
