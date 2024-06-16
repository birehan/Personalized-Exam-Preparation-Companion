import '../../../features.dart';

class SubChapterModel extends SubChapter {
  const SubChapterModel({
    required super.id,
    required super.chapterId,
    required super.name,
    required super.contents,
  });

  factory SubChapterModel.fromJson(Map<String, dynamic> json) {
    return SubChapterModel(
      id: json['_id'] ?? '',
      chapterId: json['chapterId'] ?? '',
      name: json['name'] ?? '',
      contents: (json['contents'] ?? [])
          .map<ContentModel>((content) => ContentModel.fromJson(content))
          .toList(),
    );
  }

  factory SubChapterModel.fromDownloadCourseJson(Map<String, dynamic> json) {
    return SubChapterModel(
      id: json['_id'] ?? '',
      chapterId: json['chapterId'] ?? '',
      name: json['name'] ?? '',
      contents: (json['subChapterContents'] ?? [])
          .map<ContentModel>((content) => ContentModel.fromJson(content))
          .toList(),
    );
  }
}
