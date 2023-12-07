import '../../../features.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required super.id,
    required super.courseId,
    required super.chapterIds,
    required super.userId,
    required super.name,
    required super.score,
    required super.isComplete,
    super.questionIds,
    super.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      chapterIds: (json['chapters'] ?? [])
          .map<String>((chapter) => chapter as String)
          .toList(),
      questionIds: (json['questions'] ?? [])
          .map<String>((questionId) => questionId as String)
          .toList(),
      score: json['score'],
      isComplete: json['completed'],
    );
  }

  factory QuizModel.fromQuizByIdJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      userId: json['userId'],
      name: json['name'] ?? '',
      chapterIds: (json['chapters'] ?? [])
          .map<String>((chapter) => chapter as String)
          .toList(),
      questions: (json['questions'] ?? [])
          .map<Question>(
            (question) => QuestionModel.fromJson(question),
          )
          .toList(),
      score: json['score'],
      isComplete: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseId': courseId,
      'name': name,
      'chapterId': chapterIds,
      'userId': userId,
      'questionIds': questionIds,
      'question': questions,
      'score': score,
      'completed': isComplete,
    };
  }
}
