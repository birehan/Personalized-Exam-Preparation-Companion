part of 'submit_daily_quiz_answer_bloc.dart';

class SubmitDailyQuizAnswerEvent extends Equatable {
  const SubmitDailyQuizAnswerEvent({
    required this.dailyQuizAnswer,
  });

  final DailyQuizAnswer dailyQuizAnswer;

  @override
  List<Object> get props => [dailyQuizAnswer];
}
