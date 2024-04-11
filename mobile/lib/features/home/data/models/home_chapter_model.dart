import '../../../features.dart';

class HomeChapterModel extends HomeChapter {
  const HomeChapterModel({
    required super.summary,
    required super.id,
    required super.name,
    required super.description,
    required super.courseId,
    required super.courseName,
    required super.noOfSubChapters,
  });

  factory HomeChapterModel.fromJson(Map<String, dynamic> json) {
    return HomeChapterModel(
      summary: json['summary'],
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      courseId: json['courseId'] == null ? '' : json['courseId']['_id'] ?? '',
      courseName:
          json['courseId'] == null ? '' : json['courseId']['name'] ?? '',
      noOfSubChapters: json['noOfSubChapters'],
    );
  }
}
