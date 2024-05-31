import '../../../features.dart';

class ChapterVideoModel extends ChapterVideo {
  const ChapterVideoModel({
    required super.title,
    required super.order,
    required super.subchapterVideos,
    required super.id,
    required super.description,
    required super.summary,
    required super.courseId,
    required super.numberOfSubChapters,
  });

  factory ChapterVideoModel.fromJson(Map<String, dynamic> json) {
    return ChapterVideoModel(
      title: json['chapter']['name'] ?? '',
      order: json['chapter']['order'] ?? 0,
      subchapterVideos: (json['videoContents']?? [])
          .map<SubchapterVideoModel>(
            (subchapterVideo) => SubchapterVideoModel.fromJson(subchapterVideo),
          )
          .toList(),
      id: json['chapter']['_id'] ?? '',
      description: json['chapter']['description'] ?? '',
      summary: json['chapter']['summary'] ?? '',
      courseId: json['chapter']['courseId'] ?? '',
      numberOfSubChapters: json['chapter']['noOfSubChapters'] ?? 0,
    );
  }
}
