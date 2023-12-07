import 'package:equatable/equatable.dart';

import 'course_image.dart';

class Course extends Equatable {
  final String id;
  final String name;
  final String description;
  final CourseImage image;
  final int numberOfChapters;
  final String departmentId;
  final String? referenceBook;
  final String ects;
  final int grade;

  const Course(
      {required this.id,
      required this.name,
      required this.departmentId,
      required this.description,
      required this.numberOfChapters,
      required this.ects,
      required this.image,
      this.referenceBook,
      required this.grade});

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        numberOfChapters,
        departmentId,
        ects,
        image,
        grade
      ];
}
