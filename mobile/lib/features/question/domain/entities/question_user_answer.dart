import 'package:equatable/equatable.dart';

class QuestionUserAnswer extends Equatable {
  final String questionId;
  final String userAnswer;

  const QuestionUserAnswer({
    required this.questionId,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [
        questionId,
        userAnswer,
      ];
}
