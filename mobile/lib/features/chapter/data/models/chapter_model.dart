import '../../../features.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.courseId,
    required super.name,
    required super.description,
    required super.summary,
    required super.noOfSubchapters,
    required super.order,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      noOfSubchapters: json['noOfSubChapters'] ?? 0,
      id: json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      summary: json['summary'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}
