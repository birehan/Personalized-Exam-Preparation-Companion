import 'package:equatable/equatable.dart';
import 'package:prepgenie/features/profile/domain/entities/department_entity.dart';
import 'package:prepgenie/features/profile/domain/entities/school_entity.dart';

class SchoolDepartmentInfo extends Equatable {
  final List<SchoolEntity> schoolInfo;
  final List<DepartmentEntity> departmentInfo;
  final List<String> regionInfo;

  const SchoolDepartmentInfo({
    required this.schoolInfo,
    required this.departmentInfo,
    required this.regionInfo,
  });
  @override
  List<Object?> get props => [
        schoolInfo,
        departmentInfo,
        regionInfo,
      ];
}
