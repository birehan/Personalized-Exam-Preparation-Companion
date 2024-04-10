import '../../../features.dart';

class MockQuestionModel extends MockQuestion {
  const MockQuestionModel({
    required super.question,
    required super.userAnswer,
  });

  factory MockQuestionModel.fromJson(Map<String, dynamic> json) {
    return MockQuestionModel(
      question: QuestionModel.fromJson(json['question'] ?? ''),
      userAnswer: UserAnswerModel.fromJson(json['userAnswer'] ?? ''),
    );
  }
}
