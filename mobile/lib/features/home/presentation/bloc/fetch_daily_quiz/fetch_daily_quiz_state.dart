part of 'fetch_daily_quiz_bloc.dart';

class FetchDailyQuizState extends Equatable {
  const FetchDailyQuizState();

  @override
  List<Object> get props => [];
}

class FetchDailyQuizInitial extends FetchDailyQuizState {}

class FetchDailyQuizLoading extends FetchDailyQuizState {}

class FetchDailyQuizLoaded extends FetchDailyQuizState {
  const FetchDailyQuizLoaded({
    required this.dailyQuiz,
  });

  final DailyQuiz dailyQuiz;

  @override
  List<Object> get props => [dailyQuiz];
}

class FetchDailyQuizFailed extends FetchDailyQuizState {
  const FetchDailyQuizFailed({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
