import '../../../features.dart';

class GeneralDepartmentModel extends GeneralDepartment {
  const GeneralDepartmentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.departments,
    required super.isForListing,
  });

  factory GeneralDepartmentModel.fromJson(Map<String, dynamic> json) {
    return GeneralDepartmentModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isForListing: json['isForListing'] ?? '',
      departments: json['departments']
          .map<DepartmentModel>(
              (department) => DepartmentModel.fromJson(department))
          .toList(),
    );
  }
}
