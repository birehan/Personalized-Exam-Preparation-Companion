import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final SubmitUserAnswerUsecase submitUserAnswerUsecase;
  final GetEndSubtopicQuestionUsecase getEndSubtopicQuestionUsecase;

  QuestionBloc({
    required this.submitUserAnswerUsecase,
    required this.getEndSubtopicQuestionUsecase,
  }) : super(QuestionInitial()) {
    on<QuestionAnswerEvent>(_onQuestionAnswer);
    on<EndSubtopicQuestionAnswerEvent>(_onEndSubtopicQuestionAnswer);
  }
  void _onEndSubtopicQuestionAnswer(
      EndSubtopicQuestionAnswerEvent event, Emitter<QuestionState> emit) async {
    emit(
      const EndSubtopicQuestionUserState(
        status: QuestionStatus.loading,
      ),
    );
    final failureOrSubmitUserAnswer = await getEndSubtopicQuestionUsecase(
        GetEndSubtopicQuestionParams(subtopicId: event.subtopicId));
    emit(_onSubmitQuestionUserAnswerOrFailure(failureOrSubmitUserAnswer));
  }

  void _onQuestionAnswer(
      QuestionAnswerEvent event, Emitter<QuestionState> emit) async {
    emit(
      const QuestionUserState(
        status: QuestionStatus.loading,
      ),
    );
    final failureOrSubmitUserAnswer = await submitUserAnswerUsecase(
      SubmitUserAnswerParams(
        questionUserAnswers: event.questionUserAnswers,
      ),
    );
    emit(_onSubmitMockUserAnswerOrFailure(failureOrSubmitUserAnswer));
  }

  QuestionState _onSubmitMockUserAnswerOrFailure(
    Either<Failure, void> failureOrSubmitUserAnswer,
  ) {
    return failureOrSubmitUserAnswer.fold(
      (failure) => QuestionUserState(
        status: QuestionStatus.error, failure:failure
      ),
      (r) => const QuestionUserState(
        status: QuestionStatus.loaded,
      ),
    );
  }

  QuestionState _onSubmitQuestionUserAnswerOrFailure(
    Either<Failure, List<EndQuestionsAndAnswer>> failureOrSubmitUserAnswer,
  ) {
    return failureOrSubmitUserAnswer.fold(
      (failure) => EndSubtopicQuestionUserState(
        status: QuestionStatus.error, failure: failure
      ),
      (r) => EndSubtopicQuestionUserState(
        status: QuestionStatus.loaded,
        endSubtopicQuestionAnswer: r,
      ),
    );
  }
}
