import 'package:equatable/equatable.dart';

import 'department.dart';

class GeneralDepartment extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<Department> departments;
  final bool isForListing;

  const GeneralDepartment({
    required this.id,
    required this.name,
    required this.description,
    required this.departments,
    required this.isForListing,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isForListing,
      ];
}
