import '../../../features.dart';

class DepartmentCourseModel extends DepartmentCourse {
  const DepartmentCourseModel({
    required super.biology,
    required super.chemistry,
    required super.civics,
    required super.english,
    required super.maths,
    required super.physics,
    required super.sat,
    required super.others,
    required super.economics,
    required super.history,
    required super.geography,
    required super.business,
  });

  factory DepartmentCourseModel.fromJson(Map<String, dynamic> json) {
    return DepartmentCourseModel(
      biology: (json['Biology'] ?? [])
          .map<Course>(
              (biology) => CourseModel.fromDepartmentCourseJson(biology))
          .toList(),
      chemistry: (json['Chemistry'] ?? [])
          .map<Course>(
              (chemistry) => CourseModel.fromDepartmentCourseJson(chemistry))
          .toList(),
      civics: (json['Civics'] ?? [])
          .map<Course>((civics) => CourseModel.fromDepartmentCourseJson(civics))
          .toList(),
      english: (json['English'] ?? [])
          .map<Course>(
              (english) => CourseModel.fromDepartmentCourseJson(english))
          .toList(),
      maths: (json['Mathematics'] ?? [])
          .map<Course>((maths) => CourseModel.fromDepartmentCourseJson(maths))
          .toList(),
      physics: (json['Physics'] ?? [])
          .map<Course>(
              (physics) => CourseModel.fromDepartmentCourseJson(physics))
          .toList(),
      sat: (json['SAT'] ?? [])
          .map<Course>((sat) => CourseModel.fromDepartmentCourseJson(sat))
          .toList(),
      others: (json['Others'] ?? [])
          .map<Course>((others) => CourseModel.fromDepartmentCourseJson(others))
          .toList(),
      economics: (json['Economics'] ?? [])
          .map<Course>((economics) => CourseModel.fromDepartmentCourseJson(economics))
          .toList(),
      history: (json['History'] ?? [])
          .map<Course>((history) => CourseModel.fromDepartmentCourseJson(history))
          .toList(),
      geography: (json['Geography'] ?? [])
          .map<Course>((geography) => CourseModel.fromDepartmentCourseJson(geography))
          .toList(),
      business: (json['Business'] ?? [])
          .map<Course>((business) => CourseModel.fromDepartmentCourseJson(business))
          .toList(),
    );
  }
}
