import 'package:equatable/equatable.dart';

class SubchapterVideo extends Equatable {
  final String title;
  final String videoLink;
  final String duration;
  final String id;
  final String courseId;
  final String chapterId;
  final String subChapterId;
  final int order;
  final String thumbnailUrl;
  bool isCompleted;

  SubchapterVideo({
    required this.id,
    required this.courseId,
    required this.chapterId,
    required this.subChapterId,
    required this.order,
    required this.title,
    required this.videoLink,
    required this.duration,
    required this.thumbnailUrl,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        id,
        courseId,
        chapterId,
        subChapterId,
        order,
        title,
        videoLink,
        duration,
        thumbnailUrl,
        isCompleted,
      ];
}
