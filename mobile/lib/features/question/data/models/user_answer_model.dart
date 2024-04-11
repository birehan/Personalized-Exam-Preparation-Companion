import '../../../features.dart';

class UserAnswerModel extends UserAnswer {
  const UserAnswerModel({
    required super.userId,
    required super.questionId,
    required super.userAnswer,
  });

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      userId: json['userId'] ?? '',
      questionId: json['questionId'] ?? '',
      userAnswer: json['userAnswer'] ?? '',
    );
  }
}
