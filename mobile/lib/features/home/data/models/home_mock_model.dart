import '../../../features.dart';

class HomeMockModel extends HomeMock {
  const HomeMockModel({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.examYear,
    required super.subject,
  });

  factory HomeMockModel.fromJson(Map<String, dynamic> json) {
    return HomeMockModel(
      id: json['_id'],
      name: json['name'],
      departmentId: json['departmentId'],
      examYear: json['examYear'],
      subject: json['subject'],
    );
  }
}
