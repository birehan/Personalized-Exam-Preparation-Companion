import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final String id;
  final String name;
  final String description;
  final int numberOfCourses;
  final String generalDepartmentId;

  const Department({
    required this.id,
    required this.name,
    required this.description,
    required this.numberOfCourses,
    required this.generalDepartmentId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        numberOfCourses,
        generalDepartmentId,
      ];
}
