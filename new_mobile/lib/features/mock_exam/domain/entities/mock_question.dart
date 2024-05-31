import 'package:equatable/equatable.dart';

import '../../../features.dart';

class MockQuestion extends Equatable {
  final Question question;
  final UserAnswer userAnswer;

  const MockQuestion({
    required this.question,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [
        question,
        userAnswer,
      ];
}
