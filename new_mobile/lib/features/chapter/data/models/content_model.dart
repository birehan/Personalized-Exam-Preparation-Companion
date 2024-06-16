import '../../../features.dart';

class ContentModel extends Content {
  const ContentModel({
    required super.id,
    required super.subChapterId,
    required super.title,
    required super.content,
    required super.isBookmarked,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'] ?? '',
      subChapterId: json['subChapterId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isBookmarked: json['isbookmarked'] ?? false,
    );
  }
}
