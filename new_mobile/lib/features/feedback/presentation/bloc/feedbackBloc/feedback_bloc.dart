import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/feedback_entity.dart';
import '../../../domain/usecases/feedback_submission_usecase.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SubmitContentFeedbackUsecase submitContentFeedbackUsecase;

  FeedbackBloc({required this.submitContentFeedbackUsecase})
      : super(FlagingInitial()) {
    on<FeedbackSubmittedEvent>(_onFeedbackSubmission);
  }
  void _onFeedbackSubmission(
      FeedbackSubmittedEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackSubmissionInProgress());
    Either<Failure, void> response = await submitContentFeedbackUsecase(
      FeedbackParams(feedback: event.feedback),
    );
    response.fold(
      (failure) => emit(FeedbackSubmisionFailedState(errorMessage: failure.errorMessage, failure: failure)),
      (feedback) => emit((FeedbackSubmitedState())),
    );
  }
}
