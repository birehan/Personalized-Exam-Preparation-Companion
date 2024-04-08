import 'package:skill_bridge_mobile/features/contest/domain/entities/contest_category.dart';

class ContestCategoryModel extends ContestCategory {
  const ContestCategoryModel({
    required super.title,
    required super.subject,
    required super.contestId,
    required super.numberOfQuestion,
    required super.categoryId,
    required super.isSubmitted,
    required super.userScore,
  });

  factory ContestCategoryModel.fromJson(Map<String, dynamic> json) {
    return ContestCategoryModel(
        title: json['title'],
        subject: json['subject'],
        contestId: json['contestId'],
        numberOfQuestion: json['numOfQuestions'],
        categoryId: json['_id'],
        isSubmitted: json['isSubmitted'],
        userScore: json['userScore']);
  }
}
