import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';

class ConsistencyModel extends ConsistencyEntity {
  const ConsistencyModel({
    required super.day,
    required super.quizCompleted,
    required super.chapterCompleted,
    required super.subChapterCopleted,
    required super.mockCompleted,
    required super.questionCompleted,
    required super.overallPoint,
  });
  factory ConsistencyModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyModel(
      day: json['day'] == null ? DateTime.now() : DateTime.parse(json['day']),
      quizCompleted: json['quizCompleted'] ?? 0,
      chapterCompleted: json['chapterCompleted'] ?? 0,
      subChapterCopleted: json['subchapterCompleted'] ?? 0,
      mockCompleted: json['mockCompleted'] ?? 0,
      questionCompleted: json['questionCompleted'] ?? 0,
      overallPoint: json['points'] ?? 0,
    );
  }
}
