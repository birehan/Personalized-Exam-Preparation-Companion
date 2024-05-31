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
  final String errorMessage;
  final Failure failure;
  
  const FetchDailyQuizForAnalysisFailed({required this.errorMessage, required this.failure});


  @override
  List<Object> get props => [errorMessage];
}
