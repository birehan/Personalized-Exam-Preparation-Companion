import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final String id;
  final String courseId;
  final String name;
  final String description;
  final String summary;
  final int noOfSubchapters;
  final int order;

  const Chapter({
    required this.noOfSubchapters,
    required this.id,
    required this.courseId,
    required this.name,
    required this.description,
    required this.summary,
    required this.order,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        name,
        description,
        summary,
        order,
      ];
}
