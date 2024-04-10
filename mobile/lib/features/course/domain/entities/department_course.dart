import 'package:equatable/equatable.dart';

import '../../../features.dart';

class DepartmentCourse extends Equatable {
  final List<Course> biology;
  final List<Course> chemistry;
  final List<Course> civics;
  final List<Course> english;
  final List<Course> maths;
  final List<Course> physics;
  final List<Course> sat;
  final List<Course> others;
  final List<Course> economics;
  final List<Course> history;
  final List<Course> geography;
  final List<Course> business;

  const DepartmentCourse({
    required this.biology,
    required this.chemistry,
    required this.civics,
    required this.english,
    required this.maths,
    required this.physics,
    required this.sat,
    required this.others,
    required this.economics,
    required this.history,
    required this.geography,
    required this.business,
  });

  @override
  List<Object?> get props => [
        biology,
        chemistry,
        civics,
        english,
        maths,
        physics,
        sat,
        others,
        economics,
        history,
        geography,
        business,
      ];
}
