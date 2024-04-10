import 'package:equatable/equatable.dart';

class DailyQuizAnswer extends Equatable {
  final String dailyQuizId;
  final List<DailyQuizUserAnswer> userAnswer;

  const DailyQuizAnswer({
    required this.dailyQuizId,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [dailyQuizId, userAnswer];
}

class DailyQuizUserAnswer extends Equatable {
  final String questionId;
  final String userAnswer;

  const DailyQuizUserAnswer({
    required this.questionId,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [questionId, userAnswer];
}
