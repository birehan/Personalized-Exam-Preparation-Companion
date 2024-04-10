part of 'fetch_daily_quiz_for_analysis_bloc.dart';

class FetchDailyQuizForAnalysisState extends Equatable {
  const FetchDailyQuizForAnalysisState();

  @override
  List<Object> get props => [];
}

class FetchDailyQuizForAnalysisInitial extends FetchDailyQuizForAnalysisState {}

class FetchDailyQuizForAnalysisLoading extends FetchDailyQuizForAnalysisState {}

class FetchDailyQuizForAnalysisLoaded extends FetchDailyQuizForAnalysisState {
  const FetchDailyQuizForAnalysisLoaded({
    required this.dailyQuiz,
  });

  final DailyQuiz dailyQuiz;

  @override
  List<Object> get props => [dailyQuiz];
}

class FetchDailyQuizForAnalysisFailed extends FetchDailyQuizForAnalysisState {
  const FetchDailyQuizForAnalysisFailed({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
