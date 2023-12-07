import '../../../features.dart';

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.id,
    required super.name,
    required super.userId,
    required super.questionAnswers,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['quiz']['_id'],
      name: json['quiz']['name'],
      userId: json['quiz']['userId'],
      questionAnswers: (json['quizQuestions'] ?? []).map<QuestionAnswer>(
        (questionAnswerModel) =>
            QuestionAnswerModel.fromJson(questionAnswerModel),
      ).toList(),
    );
  }
}
