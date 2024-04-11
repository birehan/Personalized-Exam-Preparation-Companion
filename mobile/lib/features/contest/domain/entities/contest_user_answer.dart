import 'package:equatable/equatable.dart';

class ContestUserAnswer extends Equatable {
  final String contestCategoryId;
  final List<ContestAnswer> userAnswers;

  const ContestUserAnswer({
    required this.contestCategoryId,
    required this.userAnswers,
  });

  @override
  List<Object?> get props => [contestCategoryId, userAnswers];
}

class ContestAnswer extends Equatable {
  const ContestAnswer({
    required this.contestQuestionId,
    required this.userAnswer,
  });

  final String contestQuestionId;
  final String userAnswer;

  @override
  List<Object?> get props => [contestQuestionId, userAnswer];
}
