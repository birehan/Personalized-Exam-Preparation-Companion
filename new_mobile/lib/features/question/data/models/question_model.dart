import '../../../features.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.courseId,
    required super.chapterId,
    required super.subChapterId,
    required super.description,
    required super.choiceA,
    required super.choiceB,
    required super.choiceC,
    required super.choiceD,
    required super.answer,
    required super.explanation,
    required super.isForQuiz,
    required super.isLiked,
    super.relatedTopic,
    super.userAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      chapterId: json['chapterId'] ?? '',
      subChapterId: json['subChapterId'] ?? '',
      description: json['description'] ?? '',
      choiceA: json['choiceA'] ?? '',
      choiceB: json['choiceB'] ?? '',
      choiceC: json['choiceC'] ?? '',
      choiceD: json['choiceD'] ?? '',
      answer: json['answer'] ?? '',
      explanation: json['explanation'] ?? '',
      isForQuiz: json['isForQuiz'] ?? true,
      isLiked: json['isLiked'] ?? false,
      relatedTopic: json['relatedTopic'],
      userAnswer: json['userAnswer'] ?? 'choice_E',
    );
  }
}
