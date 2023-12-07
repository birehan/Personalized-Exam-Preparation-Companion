import '../../../features.dart';

class QuestionAnswerModel extends QuestionAnswer {
  const QuestionAnswerModel({
    required super.question,
    required super.userAnswer,
  });

  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswerModel(
      question: QuestionModel.fromJson(json['question'] ?? ''),
      userAnswer: UserAnswerModel.fromJson(
        json['userAnswer'] ?? '',
      ),
    );
  }
}
