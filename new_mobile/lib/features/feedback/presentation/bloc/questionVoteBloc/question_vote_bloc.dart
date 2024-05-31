import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/usecases/vote_question_usecase.dart';

part 'question_vote_event.dart';
part 'question_vote_state.dart';

class QuestionVoteBloc extends Bloc<QuestionVoteEvent, QuestionVoteState> {
  final VoteQuestionUsecase voteQuestionUsecase;
  QuestionVoteBloc({required this.voteQuestionUsecase})
      : super(QuestionVoteInitial()) {
    on<QuestionVotedEvent>(_onQuestionvoted);
  }
  _onQuestionvoted(
      QuestionVotedEvent event, Emitter<QuestionVoteState> emit) async {
    emit(QuestionVoteLoadingState());
    Either<Failure, void> response = await voteQuestionUsecase(
        VoteQuestionParams(
            questionId: event.questionId, isLiked: event.isLiked));
    response.fold(
      (failiure) => emit(QuestionVoteFailedState(failure: failiure)),
      (r) => emit(QuestionVotedState()),
    );
  }
}
