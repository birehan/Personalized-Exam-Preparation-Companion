import 'package:equatable/equatable.dart';

import '../../../features.dart';

class DailyQuiz extends Equatable {
  final String id;
  final DateTime? day;
  final String description;
  final String? departmentId;
  final List<DailyQuizQuestion> dailyQuizQuestions;
  final bool? isSolved;
  final int userScore;
  final String? userId;

  const DailyQuiz({
    required this.id,
    this.day,
    required this.description,
    this.departmentId,
    required this.dailyQuizQuestions,
    this.isSolved,
    required this.userScore,
    this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        day,
        description,
        departmentId,
        dailyQuizQuestions,
        isSolved,
        userScore,
        userId,
      ];
}
