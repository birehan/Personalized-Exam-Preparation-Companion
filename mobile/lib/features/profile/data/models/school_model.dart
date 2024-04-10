import 'package:skill_bridge_mobile/features/profile/domain/entities/department_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_info_enitity.dart';

class SchoolDepartmentModel extends SchoolDepartmentInfo {
  const SchoolDepartmentModel({
    required super.schoolInfo,
    required super.departmentInfo,
    required super.regionInfo,
  });
  factory SchoolDepartmentModel.fromJson(Map<String, dynamic> json) {
    final schoolData = json['schools'] ?? <Map<String, dynamic>>[];
    final departmentData = json['departments'] ?? <Map<String, dynamic>>[];
    // final regionData = json['regions'] ?? <Map<String, String>>[];

    return SchoolDepartmentModel(
      schoolInfo: schoolData
          .map<SchoolEntity>((data) => SchoolModel.fromJson(data))
          .toList(),
      departmentInfo: departmentData
          .map<DepartmentEntity>((data) => DepartmentModel.fromJson(data))
          .toList(),
      regionInfo:
          json['regions'].map<String>((data) => data.toString()).toList(),
    );
  }
}

class SchoolModel extends SchoolEntity {
  const SchoolModel(
      {required super.schoolId,
      required super.schoolName,
      required super.region});

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      schoolId: json['_id'] ?? '',
      schoolName: json['name'] ?? '',
      region: json['region'] ?? '',
    );
  }
}

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel(
      {required super.departmentId, required super.departmentName});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['_id'],
      departmentName: json['name'],
    );
  }
}
