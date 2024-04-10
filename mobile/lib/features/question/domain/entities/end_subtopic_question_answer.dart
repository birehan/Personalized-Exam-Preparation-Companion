import 'package:equatable/equatable.dart';

import '../../../features.dart';

class EndQuestionsAndAnswer extends Equatable {
  final Question question;
  final UserAnswer userAnswer;

  const EndQuestionsAndAnswer({
    required this.question,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [
        question,
        userAnswer,
      ];
}
