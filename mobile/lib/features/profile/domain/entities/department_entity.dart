import 'package:equatable/equatable.dart';

class DepartmentEntity extends Equatable {
  final String departmentId;
  final String departmentName;

  const DepartmentEntity({
    required this.departmentId,
    required this.departmentName,
  });
  @override
  List<Object?> get props => [];
}
