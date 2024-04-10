import '../../../features.dart';

class SubchapterVideoModel extends SubchapterVideo {
  const SubchapterVideoModel({
    required super.title,
    required super.videoLink,
    required super.duration,
    required super.id,
    required super.courseId,
    required super.chapterId,
    required super.subChapterId,
    required super.order,
    required super.thumbnailUrl,
  });

  factory SubchapterVideoModel.fromJson(Map<String, dynamic> json) {
    return SubchapterVideoModel(
      title: json['title'] ?? '',
      videoLink: json['link'] ?? '',
      duration: json['duration'] ?? '0:00',
      id: json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      chapterId: json['chapterId'] ?? '',
      subChapterId: json['subChapterId'] ?? '',
      order: json['order'] ?? 0,
      thumbnailUrl: json['thumbnail'] ?? '',
    );
  }
}
