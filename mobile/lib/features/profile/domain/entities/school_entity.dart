import 'package:equatable/equatable.dart';

class SchoolEntity extends Equatable {
  final String schoolId;
  final String schoolName;
  final String region;

  const SchoolEntity({
    required this.schoolId,
    required this.schoolName,
    required this.region,
  });

  @override
  List<Object?> get props => [schoolId, schoolName, region];
}
