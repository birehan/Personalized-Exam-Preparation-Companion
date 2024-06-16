import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../features.dart';

part 'fetch_daily_quiz_for_analysis_event.dart';
part 'fetch_daily_quiz_for_analysis_state.dart';

class FetchDailyQuizForAnalysisBloc extends Bloc<FetchDailyQuizForAnalysisEvent,
    FetchDailyQuizForAnalysisState> {
  FetchDailyQuizForAnalysisBloc({
    required this.fetchDailyQuizForAnalysisUsecase,
  }) : super(FetchDailyQuizForAnalysisInitial()) {
    on<FetchDailyQuizForAnalysisByIdEvent>(_onFetchDailyQuizForAnalysis);
    on<FetchDailyQuizForAnalysisInitialEvent>(
        _onFetchDailyQuizForAnalysisInitial);
  }

  final FetchDailyQuizForAnalysisUsecase fetchDailyQuizForAnalysisUsecase;

  void _onFetchDailyQuizForAnalysis(FetchDailyQuizForAnalysisByIdEvent event,
      Emitter<FetchDailyQuizForAnalysisState> emit) async {
    emit(FetchDailyQuizForAnalysisLoading());
    final failureOrDailyQuiz = await fetchDailyQuizForAnalysisUsecase(
      FetchDailyQuizForAnalysisParams(id: event.id),
    );
    emit(
      failureOrDailyQuiz.fold(
        (failure) => FetchDailyQuizForAnalysisFailed(errorMessage: failure.errorMessage, failure: failure),
        (dailyQuiz) => FetchDailyQuizForAnalysisLoaded(dailyQuiz: dailyQuiz),
      ),
    );
  }

  void _onFetchDailyQuizForAnalysisInitial(
      FetchDailyQuizForAnalysisInitialEvent event,
      Emitter<FetchDailyQuizForAnalysisState> emit) {
    emit(FetchDailyQuizForAnalysisInitial());
  }
}
