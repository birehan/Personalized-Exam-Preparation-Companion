import '../../../features.dart';

class UserMockModel extends UserMock {
  const UserMockModel({
    required super.id,
    required super.name,
    required super.numberOfQuestions,
    required super.departmentId,
    required super.isCompleted,
    required super.score,
  });

  factory UserMockModel.fromJson(Map<String, dynamic> json) {
    return UserMockModel(
      id: json['mock']['_id'] ?? '',
      name: json['mock']['name'] ?? '',
      numberOfQuestions: json['mock']['questions'] ?? 0,
      departmentId: json['mock']['departmentId'] ?? '',
      isCompleted: json['completed'] ?? false,
      score: json['score'] ?? 0,
    );
  }
}
