import 'package:equatable/equatable.dart';

class HomeChapter extends Equatable {
  const HomeChapter({
    required this.summary,
    required this.id,
    required this.name,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.noOfSubChapters,
  });

  final String summary;
  final String id;
  final String name;
  final String description;
  final String courseId;
  final String courseName;
  final int noOfSubChapters;

  @override
  List<Object?> get props =>
      [summary, id, name, description, courseId, courseName, noOfSubChapters];
}
