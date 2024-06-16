import '../../../features.dart';

class EEndQuestionsAndAnswerModel extends EndQuestionsAndAnswer {
  const EEndQuestionsAndAnswerModel({
    required super.question,
    required super.userAnswer,
  });

  factory EEndQuestionsAndAnswerModel.fromJson(Map<String, dynamic> json) {
    return EEndQuestionsAndAnswerModel(
      question: QuestionModel.fromJson(json['question'] ?? ''),
      userAnswer: UserAnswerModel.fromJson(json['userAnswer'] ?? ''),
    );
  }
}
