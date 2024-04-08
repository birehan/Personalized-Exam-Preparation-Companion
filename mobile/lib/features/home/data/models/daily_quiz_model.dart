import '../../../features.dart';

class DailyQuizModel extends DailyQuiz {
  const DailyQuizModel({
    required super.id,
    super.day,
    required super.description,
    super.departmentId,
    required super.dailyQuizQuestions,
    super.isSolved,
    required super.userScore,
    super.userId,
  });

  factory DailyQuizModel.fromJson(Map<String, dynamic> json) {
    return DailyQuizModel(
      id: json['dailyQuiz']['_id'] ?? '',
      day: DateTime.tryParse(json['dailyQuiz']['day']) ?? DateTime.now(),
      description: json['dailyQuiz']['description'] ?? '',
      departmentId: json['dailyQuiz']['departmentId'] ?? '',
      dailyQuizQuestions: (json['dailyQuiz']['questions'] ?? [])
          .map<DailyQuizQuestionModel>(
              (question) => DailyQuizQuestionModel.fromJson(question))
          .toList(),
      isSolved: json['isSolved'] ?? false,
      userScore: json['userScore'] ?? 0,
    );
  }

  factory DailyQuizModel.fromAnalysisJson(Map<String, dynamic> json) {
    return DailyQuizModel(
      id: json['dailyQuiz']['_id'] ?? '',
      description: json['dailyQuiz']['description'] ?? '',
      dailyQuizQuestions: (json['quizQuestions'] ?? [])
          .map<DailyQuizQuestionModel>(
              (question) => DailyQuizQuestionModel.fromAnalysisJson(question))
          .toList(),
      userScore: json['dailyQuiz']['userScore'] ?? 0,
      userId: json['dailyQuiz']['userId'] ?? '',
    );
  }
}
