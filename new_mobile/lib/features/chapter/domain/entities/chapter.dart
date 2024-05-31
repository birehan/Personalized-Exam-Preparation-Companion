import 'package:equatable/equatable.dart';

import '../../../features.dart';

class Chapter extends Equatable {
  final String id;
  final String courseId;
  final String name;
  final String description;
  final String summary;
  final int noOfSubchapters;
  final int order;
  final List<SubChapter>? subChapters;

  const Chapter({
    required this.noOfSubchapters,
    required this.id,
    required this.courseId,
    required this.name,
    required this.description,
    required this.summary,
    required this.order,
    this.subChapters,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        name,
        description,
        summary,
        order,
        subChapters,
      ];
}
