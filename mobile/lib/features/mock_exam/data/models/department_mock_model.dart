import '../../../features.dart';

class DepartmentMockModel extends DepartmentMock {
  const DepartmentMockModel({
    required super.id,
    required super.mockExams,
  });

  factory DepartmentMockModel.fromJson(Map<String, dynamic> json) {
    return DepartmentMockModel(
      id: json['_id'] ?? '',
      mockExams: (json['mocks'] ?? [])
          .map<MockExamModel>(
            (mock) => MockExamModel.fromDepartmentMocksJson(mock),
          )
          .toList(),
    );
  }
}
