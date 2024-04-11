import 'package:equatable/equatable.dart';

import '../../../features.dart';

class Quiz extends Equatable {
  final String id;
  final String courseId;
  final List<String> chapterIds;
  final String userId;
  final String name;
  final List<String>? questionIds;
  final List<Question>? questions;
  final int score;
  final bool isComplete;

  const Quiz({
    required this.id,
    required this.courseId,
    required this.chapterIds,
    required this.userId,
    required this.name,
    required this.questionIds,
    required this.questions,
    required this.score,
    required this.isComplete,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        chapterIds,
        userId,
        name,
        questionIds,
        questions,
        score,
        isComplete,
      ];
}
