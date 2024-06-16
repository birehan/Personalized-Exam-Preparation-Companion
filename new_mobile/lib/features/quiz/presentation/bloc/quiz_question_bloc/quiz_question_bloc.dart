import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'quiz_question_event.dart';
part 'quiz_question_state.dart';

class QuizQuestionBloc extends Bloc<QuizQuestionEvent, QuizQuestionState> {
  final GetQuizByIdUsecase getQuizByIdUsecase;
  final SaveQuizScoreUsecase saveQuizScoreUsecase;

  QuizQuestionBloc({
    required this.getQuizByIdUsecase,
    required this.saveQuizScoreUsecase,
  }) : super(QuizQuestionInitial()) {
    on<GetQuizByIdEvent>(_onGetQuizById);
    on<GetQuizAnalysisEvent>(_onGetQuizAnalysis);
    on<SaveQuizScoreEvent>(_onSaveQuizScore);
  }

  void _onGetQuizById(
      GetQuizByIdEvent event, Emitter<QuizQuestionState> emit) async {
    emit(const GetQuizByIdState(status: QuizQuestionStatus.loading));
    final failureOrQuizQuestion = await getQuizByIdUsecase(
      GetQuizByIdParams(
        quizId: event.quizId,
        isRefreshed: event.isRefreshed,
      ),
    );
    emit(_quizQuestionOrFailure(failureOrQuizQuestion));
  }

  QuizQuestionState _quizQuestionOrFailure(
      Either<Failure, QuizQuestion> failureOrQuizQuestion) {
    return failureOrQuizQuestion.fold(
      (failure) => GetQuizByIdState(status: QuizQuestionStatus.error, failure: failure),
      (quizQuestion) => GetQuizByIdState(
        status: QuizQuestionStatus.loaded,
        quizQuestion: quizQuestion,
      ),
    );
  }

  void _onGetQuizAnalysis(
      GetQuizAnalysisEvent event, Emitter<QuizQuestionState> emit) async {
    emit(const GetQuizAnalysisState(status: QuizQuestionStatus.loading));
    final failureOrQuizQuestion = await getQuizByIdUsecase(
      GetQuizByIdParams(quizId: event.quizId, isRefreshed: true),
    );
    emit(_quizAnalysisOrFailure(failureOrQuizQuestion));
  }

  QuizQuestionState _quizAnalysisOrFailure(
      Either<Failure, QuizQuestion> failureOrQuizQuestion) {
    return failureOrQuizQuestion.fold(
      (failure) => GetQuizAnalysisState(status: QuizQuestionStatus.error, failure:failure),
      (quizQuestion) => GetQuizAnalysisState(
        status: QuizQuestionStatus.loaded,
        quizQuestion: quizQuestion,
      ),
    );
  }

  void _onSaveQuizScore(
      SaveQuizScoreEvent event, Emitter<QuizQuestionState> emit) async {
    emit(const SaveQuizScoreState(status: QuizQuestionStatus.loading));
    final failureOrSaveQuizScore = await saveQuizScoreUsecase(
      SaveQuizScoreParams(
        quizId: event.quizId,
        score: event.score,
      ),
    );
    emit(_saveQuizScoreOrFailure(failureOrSaveQuizScore));
  }

  QuizQuestionState _saveQuizScoreOrFailure(
      Either<Failure, void> failureOrSaveQuizScore) {
    return failureOrSaveQuizScore.fold(
      (failure) => SaveQuizScoreState(status: QuizQuestionStatus.error, failure:failure),
      (r) => const SaveQuizScoreState(status: QuizQuestionStatus.loaded),
    );
  }
}
