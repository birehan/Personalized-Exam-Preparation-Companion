part of 'submit_daily_quiz_answer_bloc.dart';

class SubmitDailyQuizAnswerState extends Equatable {
  const SubmitDailyQuizAnswerState();

  @override
  List<Object> get props => [];
}

class SubmitDailyQuizAnswerInitial extends SubmitDailyQuizAnswerState {}

class SubmitDailyQuizAnswerLoading extends SubmitDailyQuizAnswerState {}

class SubmitDailyQuizAnswerLoaded extends SubmitDailyQuizAnswerState {}

class SubmitDailyQuizAnswerFailed extends SubmitDailyQuizAnswerState {
  final String errorMessage;

  const SubmitDailyQuizAnswerFailed({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
