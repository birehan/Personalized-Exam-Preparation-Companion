import '../../../features.dart';

class ContestQuestionModel extends ContestQuestion {
  const ContestQuestionModel({
    required super.id,
    required super.contestCategoryId,
    required super.chapterId,
    required super.courseId,
    required super.subChapterId,
    required super.description,
    required super.choiceA,
    required super.choiceB,
    required super.choiceC,
    required super.choiceD,
    required super.relatedTopic,
    required super.difficulty,
    required super.answer,
    required super.explanation,
    required super.userAnswer,
  });

  factory ContestQuestionModel.fromJson(Map<String, dynamic> json) {
    return ContestQuestionModel(
      id: json['_id'],
      contestCategoryId: json['contestCategoryId'],
      chapterId: json['chapterId'],
      courseId: json['courseId'],
      subChapterId: json['subChapterId'],
      description: json['description'],
      choiceA: json['choiceA'],
      choiceB: json['choiceB'],
      choiceC: json['choiceC'],
      choiceD: json['choiceD'],
      relatedTopic: json['relatedTopic'],
      difficulty: json['difficulty'],
      answer: '',
      explanation: '',
      userAnswer: '',
    );
  }

  factory ContestQuestionModel.fromAnalysisJson(Map<String, dynamic> json) {
    return ContestQuestionModel(
      id: json['question']['_id'],
      contestCategoryId: json['question']['contestCategoryId'],
      chapterId: json['question']['chapterId'],
      courseId: json['question']['courseId'],
      subChapterId: json['question']['subChapterId'],
      description: json['question']['description'],
      choiceA: json['question']['choiceA'],
      choiceB: json['question']['choiceB'],
      choiceC: json['question']['choiceC'],
      choiceD: json['question']['choiceD'],
      relatedTopic: json['question']['relatedTopic'],
      difficulty: json['question']['difficulty'],
      answer: json['question']['answer'],
      explanation: json['question']['explanation'],
      userAnswer: json['userAnswer']['userAnswer'],
    );
  }
}
