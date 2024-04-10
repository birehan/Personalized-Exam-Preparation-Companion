import 'package:skill_bridge_mobile/features/features.dart';

class UserAnswersModel extends UserAnswer {
  const UserAnswersModel({
    required super.userId,
    required super.questionId,
    required super.userAnswer,
  });
  factory UserAnswersModel.fromJson(Map<String, dynamic> json) {
    return UserAnswersModel(
      userId: json['userId'] ?? '',
      questionId: json['questionId'] ?? '',
      userAnswer: json['userAnswer'] ?? '',
    );
  }
}
