import '../../../features.dart';

class DepartmentModel extends Department {
  const DepartmentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.numberOfCourses,
    required super.generalDepartmentId,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      numberOfCourses: json['noOfCourses'] ?? 0,
      generalDepartmentId: json['generalDepartmentId'] ?? '',
    );
  }
}
