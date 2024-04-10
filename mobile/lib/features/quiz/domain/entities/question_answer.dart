import 'package:equatable/equatable.dart';

import '../../../features.dart';

class QuestionAnswer extends Equatable {
  final Question question;
  final UserAnswer userAnswer;

  const QuestionAnswer({
    required this.question,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [question, userAnswer];
}
