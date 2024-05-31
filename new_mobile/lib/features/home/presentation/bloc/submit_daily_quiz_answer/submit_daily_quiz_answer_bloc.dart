import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features.dart';

part 'submit_daily_quiz_answer_event.dart';
part 'submit_daily_quiz_answer_state.dart';

class SubmitDailyQuizAnswerBloc
    extends Bloc<SubmitDailyQuizAnswerEvent, SubmitDailyQuizAnswerState> {
  SubmitDailyQuizAnswerBloc({
    required this.submitDailyQuizAnswerUsecase,
  }) : super(SubmitDailyQuizAnswerInitial()) {
    on<SubmitDailyQuizAnswerEvent>(_onSubmitDailyQuizAnswer);
  }

  final SubmitDailyQuizAnswerUsecase submitDailyQuizAnswerUsecase;

  void _onSubmitDailyQuizAnswer(SubmitDailyQuizAnswerEvent event,
      Emitter<SubmitDailyQuizAnswerState> emit) async {
    emit(SubmitDailyQuizAnswerLoading());
    final failureOrSuccess = await submitDailyQuizAnswerUsecase(
      SubmitDailyQuizAnswerParams(dailyQuizAnswer: event.dailyQuizAnswer),
    );
    emit(
      failureOrSuccess.fold(
        (l) => SubmitDailyQuizAnswerFailed(errorMessage: l.errorMessage),
        (_) => SubmitDailyQuizAnswerLoaded(),
      ),
    );
  }
}
