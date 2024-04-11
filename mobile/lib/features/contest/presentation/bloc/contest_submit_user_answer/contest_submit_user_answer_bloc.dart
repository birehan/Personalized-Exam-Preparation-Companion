import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features.dart';

part 'contest_submit_user_answer_event.dart';
part 'contest_submit_user_answer_state.dart';

class ContestSubmitUserAnswerBloc
    extends Bloc<ContestSubmitUserAnswerEvent, ContestSubmitUserAnswerState> {
  ContestSubmitUserAnswerBloc({
    required this.contestSubmitUserAnswerUsecase,
  }) : super(ContestSubmitUserAnswerInitial()) {
    on<ContestSubmitUserAnswerEvent>(_onContestSubmitUserAnswer);
  }

  final SubmitContestUserAnswerUsecase contestSubmitUserAnswerUsecase;

  void _onContestSubmitUserAnswer(ContestSubmitUserAnswerEvent event,
      Emitter<ContestSubmitUserAnswerState> emit) async {
    emit(ContestSubmitUserAnswerLoading());
    final failureOrSuccess = await contestSubmitUserAnswerUsecase(
      SubmitContestUserAnswerParams(contestUserAnswer: event.contestUserAnswer),
    );
    emit(failureOrSuccess.fold(
      (l) => ContestSubmitUserAnswerFailed(errorMessage: l.errorMessage),
      (r) => ContestSubmitUserAnswerLoaded(),
    ));
  }
}
