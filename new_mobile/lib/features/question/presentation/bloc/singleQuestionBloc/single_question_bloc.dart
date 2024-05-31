import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/question/domain/usecases/get_question_by_id_usecase.dart';

part 'single_question_event.dart';
part 'single_question_state.dart';

class SingleQuestionBloc
    extends Bloc<SingleQuestionEvent, SingleQuestionState> {
  final GetQuestionByIdUsecase getQuestionByIdUsecase;
  SingleQuestionBloc({required this.getQuestionByIdUsecase})
      : super(SingleQuestionInitial()) {
    on<GetQuestionByIdEvent>((event, emit) async {
      emit(SingleQuestionLoadingState());
      final failureOrQuestion = await getQuestionByIdUsecase(
          GetQuestionByIdParams(questionId: event.questionId));
      final state = failureOrQuestion.fold(
          (l) => SingleQuestionFailedState(failure: l),
          (r) => SingleQuestionLoadedState(question: r));
      emit(state);
    });
  }
}
