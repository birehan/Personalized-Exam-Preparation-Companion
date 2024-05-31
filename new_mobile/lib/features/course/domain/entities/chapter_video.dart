import 'package:equatable/equatable.dart';

import '../../../features.dart';

class ChapterVideo extends Equatable {
  final String id;
  final String title;
  final String description;
  final String summary;
  final String courseId;
  final int numberOfSubChapters;
  final int order;
  final List<SubchapterVideo> subchapterVideos;

  const ChapterVideo({
    required this.id,
    required this.description,
    required this.summary,
    required this.courseId,
    required this.numberOfSubChapters,
    required this.title,
    required this.order,
    required this.subchapterVideos,
  });

  @override
  List<Object> get props => [
        id,
        description,
        summary,
        courseId,
        numberOfSubChapters,
        title,
        order,
        subchapterVideos
      ];
}
