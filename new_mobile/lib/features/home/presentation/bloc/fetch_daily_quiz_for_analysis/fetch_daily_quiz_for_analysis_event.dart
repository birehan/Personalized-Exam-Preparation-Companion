part of 'fetch_daily_quiz_for_analysis_bloc.dart';

class FetchDailyQuizForAnalysisEvent extends Equatable {
  const FetchDailyQuizForAnalysisEvent();

  @override
  List<Object> get props => [];
}

class FetchDailyQuizForAnalysisByIdEvent
    extends FetchDailyQuizForAnalysisEvent {
  const FetchDailyQuizForAnalysisByIdEvent({
    required this.id,
  });

  final String id;

  @override
  List<Object> get props => [id];
}

class FetchDailyQuizForAnalysisInitialEvent
    extends FetchDailyQuizForAnalysisEvent {}
