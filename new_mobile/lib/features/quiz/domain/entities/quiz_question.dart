import 'package:equatable/equatable.dart';

import '../../../features.dart';

class QuizQuestion extends Equatable {
  final String id;
  final String name;
  final String userId;
  final List<QuestionAnswer> questionAnswers;

  const QuizQuestion({
    required this.id,
    required this.name,
    required this.userId,
    required this.questionAnswers,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        userId,
        questionAnswers,
      ];
}
