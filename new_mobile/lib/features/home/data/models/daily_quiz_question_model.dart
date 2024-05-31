import '../../../features.dart';

class DailyQuizQuestionModel extends DailyQuizQuestion {
  const DailyQuizQuestionModel({
    required super.id,
    required super.description,
    required super.choiceA,
    required super.choiceB,
    required super.choiceC,
    required super.choiceD,
    super.answer,
    super.explanation,
    super.chapterId,
    super.courseId,
    super.subChapterId,
    super.relatedTopic,
    super.isLiked,
    super.userId,
    super.userAnswer,
  });

  factory DailyQuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return DailyQuizQuestionModel(
      id: json['_id'],
      description: json['description'],
      choiceA: json['choiceA'],
      choiceB: json['choiceB'],
      choiceC: json['choiceC'],
      choiceD: json['choiceD'],
    );
  }

  factory DailyQuizQuestionModel.fromAnalysisJson(Map<String, dynamic> json) {
    return DailyQuizQuestionModel(
      id: json['question']['_id'] ?? '',
      description: json['question']['description'] ?? '',
      choiceA: json['question']['choiceA'] ?? '',
      choiceB: json['question']['choiceB'] ?? '',
      choiceC: json['question']['choiceC'] ?? '',
      choiceD: json['question']['choiceD'] ?? '',
      answer: json['question']['answer'] ?? '',
      explanation: json['question']['explanation'] ?? '',
      chapterId: json['question']['chapterId'] ?? '',
      courseId: json['question']['courseId'] ?? '',
      subChapterId: json['question']['subChapterId'] ?? '',
      relatedTopic: json['question']['relatedTopic'] ?? '',
      isLiked: json['question']['isLiked'] ?? false,
      userId: json['userAnswer']['userId'] ?? '',
      userAnswer: json['userAnswer']['userAnswer'] ?? '',
    );
  }
}
