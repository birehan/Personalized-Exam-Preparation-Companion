import '../../../features.dart';

class QuestionUserAnswerModel extends QuestionUserAnswer {
  const QuestionUserAnswerModel({
    required super.questionId,
    required super.userAnswer,
  });

  factory QuestionUserAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuestionUserAnswerModel(
      questionId: json['questionId'] ?? '',
      userAnswer: json['userAnswer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
    };
  }
}
