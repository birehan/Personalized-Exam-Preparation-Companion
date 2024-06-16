import '../../../features.dart';

class SubchapterVideoModel extends SubchapterVideo {
  SubchapterVideoModel({
    required super.title,
    required super.videoLink,
    required super.duration,
    required super.id,
    required super.courseId,
    required super.chapterId,
    required super.subChapterId,
    required super.order,
    required super.thumbnailUrl,
    required super.isCompleted,
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
      isCompleted: json['completed'] ?? '',
    );
  }
}
